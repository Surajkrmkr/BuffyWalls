import 'package:flutter/cupertino.dart';

class DownloadWallProvider extends ChangeNotifier {
  bool _isDownloading = true;
  bool get isDownloading => _isDownloading;
  set isDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  int _progress = 0;
  int get progress => _progress;
  set progress(int value) {
    _progress = value;
    notifyListeners();
  }
}
