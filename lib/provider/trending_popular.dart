import 'package:buffywalls_3/model/trending_popular.dart';
import 'package:flutter/cupertino.dart';

import '../model/category_brand.dart';
import '../services/trending_popular.dart';

class TrendingProvider extends ChangeNotifier {
  bool isLoading = true;

  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<HomePageImage> imageList = [];
  TrendingProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await HomePageRemoteServices.fetchData('Trending');
      imageList = list.categoryImages!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      var list = await HomePageRemoteServices.fetchData('Trending');
      imageList = list.categoryImages!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    }
    await Future.delayed(const Duration(seconds: 3));
  }
}

class PopularProvider extends ChangeNotifier {
  bool isLoading = true;

  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<HomePageImage> imageList = [];
  PopularProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await HomePageRemoteServices.fetchData('popular');
      imageList = list.categoryImages!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      var list = await HomePageRemoteServices.fetchData('popular');
      imageList = list.categoryImages!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    }
    await Future.delayed(const Duration(seconds: 3));
  }
}

class FeatureProvider extends ChangeNotifier {
  bool isLoading = true;

  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<FeaturedElement> imageList = [];
  FeatureProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await HomePageRemoteServices.fetchFeatureData('Featured');
      imageList = list.featured!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }
}
