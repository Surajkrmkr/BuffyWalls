import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImage {
  static Future downloadImage(String url, String name) async {
    try {
      getPermission();
      getSnackbar(name, 'Starting Downloading...');
      await ImageDownloader.downloadImage(url,
              destination: AndroidDestinationType.directoryDownloads
                ..subDirectory('BuffyWalls/$name.jpg'))
          .then((value) => getSnackbar(name, 'Downloaded $name'));
    } on Exception catch (e) {
      getSnackbar('Wallpaper', 'Not downloaded');
    }
  }

  static getPermission() async {
    if (await Permission.storage.isDenied) {
      getSnackbar('Give storage permission', 'to Download');
      Permission.storage.request();
    } else if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
