import 'package:flutter/material.dart';

import '../services/category_brand_wall.dart';

class CategorizedProvider extends ChangeNotifier {
  var isLoading = true;
  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  var imageList = [];

  Future fetchDataFromUrl(String section, String category) async {
    setIsLoading = true;
    try {
      var list =
          await CategoryBrandWallRemoteServices.fetchData(section, category);
      imageList = list.categoryWall!.images!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
    notifyListeners();
  }

  Future<void> onRefresh(String section, String category) async {
    try {
      var list =
          await CategoryBrandWallRemoteServices.fetchData(section, category);
      imageList = list.categoryWall!.images!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    }
    await Future.delayed(const Duration(seconds: 3));
  }
}
