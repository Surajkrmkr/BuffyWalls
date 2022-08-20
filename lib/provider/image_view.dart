import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageViewProvider extends ChangeNotifier {
  bool _isTap = true;
  bool get isTap => _isTap;
  set isTap(bool value) {
    _isTap = value;
    notifyListeners();
  }

  ImageViewProvider() {
    handleShowBackToUpBtn();
  }

  String imageHeight = "0";
  String imageWidth = "0";
  getImageHeight() => imageHeight;
  getImageWidth() => imageWidth;
  setImageHeight(String value) {
    imageHeight = value;
    notifyListeners();
  }

  setImageWidth(String value) {
    imageWidth = value;
    notifyListeners();
  }

  getImageSize(dynamic url) async {
    File? image = await DefaultCacheManager().getSingleFile(url);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    setImageHeight(decodedImage.height.toString());
    setImageWidth(decodedImage.width.toString());
  }

  bool showBackToUpBtn = false;
  getShowBackToUpBtn() => showBackToUpBtn;
  setShowBackToUpBtn(bool value) {
    showBackToUpBtn = value;
    notifyListeners();
  }

  late ScrollController scrollController;

  handleShowBackToUpBtn() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset > 300) {
          setShowBackToUpBtn(true);
        } else {
          setShowBackToUpBtn(false);
        }
      });
  }

  scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
}
