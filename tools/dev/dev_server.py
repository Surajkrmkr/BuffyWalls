#!/usr/bin/env python3
"""Local stand-in for the GitLab-hosted BuffyWalls data, for development.

Serves buffy.json / startup.json from the local buffywallsjson checkout and
the wallpaper files from the local buffy_wall_data checkout, so the app can
be run and tested without touching GitLab (which rate-limits with HTTP 429).

JSON is served as text/plain because the app expects a String body, exactly
as GitLab raw does.

Override locations with BUFFY_JSON_DIR / BUFFY_DATA_DIR / PORT.
"""
import json
import mimetypes
import os
import socketserver
import urllib.parse
from http.server import BaseHTTPRequestHandler

HOME = os.path.expanduser("~")
JSON_DIR = os.environ.get("BUFFY_JSON_DIR", f"{HOME}/Team Shadow/buffywallsjson")
DATA_DIR = os.environ.get("BUFFY_DATA_DIR", f"{HOME}/Team Shadow/buffy_wall_data")
PORT = int(os.environ.get("PORT", "8765"))

GITLAB_PREFIX = "https://gitlab.com/piyushkpv/buffy_wall_data/-/raw/main/"
LOCAL_PREFIX = f"http://127.0.0.1:{PORT}/data/"


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def _send(self, body, content_type):
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urllib.parse.unquote(self.path.split("?")[0])
        if path == "/buffy.json":
            raw = open(f"{JSON_DIR}/buffy.json", "rb").read()
            return self._send(
                raw.replace(GITLAB_PREFIX.encode(), LOCAL_PREFIX.encode()),
                "text/plain; charset=utf-8",
            )
        if path == "/startup.json":
            # The real onboarding list points at another repo; use this
            # app's own thumbnails so the onboarding wall has content.
            data = json.load(open(f"{JSON_DIR}/buffy.json"))
            banners = [
                w["compressUrl"].replace(GITLAB_PREFIX, LOCAL_PREFIX)
                for w in data["popular"]
                if w.get("compressUrl")
            ][:18]
            return self._send(
                json.dumps({"banners": banners}).encode(),
                "text/plain; charset=utf-8",
            )
        if path.startswith("/data/"):
            file = os.path.join(DATA_DIR, path[len("/data/"):])
            if os.path.isfile(file):
                kind = mimetypes.guess_type(file)[0] or "application/octet-stream"
                return self._send(open(file, "rb").read(), kind)
        self.send_response(404)
        self.send_header("Content-Length", "0")
        self.end_headers()


if __name__ == "__main__":
    socketserver.ThreadingTCPServer.allow_reuse_address = True
    with socketserver.ThreadingTCPServer(("127.0.0.1", PORT), Handler) as srv:
        print(f"BuffyWalls dev server on http://127.0.0.1:{PORT}")
        srv.serve_forever()
