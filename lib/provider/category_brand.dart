import 'package:flutter/material.dart';
import '../services/category_brand.dart';

class CategoryProvider extends ChangeNotifier {
  bool isLoading = true;

  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  var imageList = [];
  CategoryProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Category');
      imageList = list.category!;
      imageList.sort((a, b) =>
          int.parse(a.id.toString()).compareTo(int.parse(b.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Category');
      imageList = list.category!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    }
    await Future.delayed(const Duration(seconds: 3));
  }
}

class BrandProvider extends ChangeNotifier {
  bool isLoading = true;

  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  var imageList = [];
  BrandProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Brands');
      imageList = list.category!;
      imageList.sort((a, b) =>
          int.parse(a.id.toString()).compareTo(int.parse(b.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Brands');
      imageList = list.category!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    }
    await Future.delayed(const Duration(seconds: 3));
  }
}
