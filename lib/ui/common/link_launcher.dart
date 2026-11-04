import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the matching app when one is installed (Play Store,
/// Instagram, Telegram...) and falls back to the browser otherwise. Plain
/// web pages such as the privacy policy have no app, so asking only for a
/// non-browser app silently did nothing.
Future<bool> openLink(String url, {bool isEmail = false}) async {
  final uri = Uri.parse(isEmail ? 'mailto:$url' : url);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
  } catch (_) {}
  if (!opened) {
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
  if (!opened) {
    Fluttertoast.showToast(msg: 'Could not open the link');
  }
  return opened;
}
