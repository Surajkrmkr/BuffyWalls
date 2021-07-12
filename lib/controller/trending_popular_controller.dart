import 'package:buffywalls/services/trending_popular.dart';
import 'package:get/get.dart';

class TrendingController extends GetxController {
  var isTrendingLoading = true.obs;

  var trendingImageList = [].obs;
  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isTrendingLoading(true);
    try {
      var list = await HomePageRemoteServices.fetchData('Trending');
      trendingImageList.value = list.categoryImages!;

      trendingImageList
        ..sort((a, b) =>
            int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isTrendingLoading(false);
    }
  }
}

class PopularController extends GetxController {
  var isPopularLoading = true.obs;

  var popularImageList = [].obs;

  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isPopularLoading(true);
    try {
      var list = await HomePageRemoteServices.fetchData('popular');
      popularImageList.value = list.categoryImages!;

      popularImageList
        ..sort((a, b) =>
            int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isPopularLoading(false);
    }
  }
}

class FeatureController extends GetxController {
  var isFeatureLoading = true.obs;

  var featureImageList = [].obs;

  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isFeatureLoading(true);
    try {
      var list = await HomePageRemoteServices.fetchData('FeaturedWalls');
      featureImageList.value = list.categoryImages!;

      featureImageList
        ..sort((a, b) =>
            int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isFeatureLoading(false);
    }
  }
}
