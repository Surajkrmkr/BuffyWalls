import 'package:buffywalls/services/category_brand.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var isLoading = true.obs;

  var imageList = [].obs;
  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isLoading(true);
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Category');
      imageList.value = list.category!;

      imageList
        ..sort((a, b) =>
            int.parse(a.id.toString()).compareTo(int.parse(b.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}

class BrandController extends GetxController {
  var isLoading = true.obs;

  var imageList = [].obs;
  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isLoading(true);
    try {
      var list = await CategoryBrandRemoteServices.fetchData('Brands');
      imageList.value = list.category!;

      imageList
        ..sort((a, b) =>
            int.parse(a.id.toString()).compareTo(int.parse(b.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}
