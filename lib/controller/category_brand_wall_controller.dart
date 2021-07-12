import 'package:buffywalls/services/category_brand_wall.dart';
import 'package:get/get.dart';

class CategorizedController extends GetxController {
  var isLoading = true.obs;

  var imageList = [].obs;
  // @override
  // onInit() {
  //   fetchDataFromUrl();
  //   super.onInit();
  // }

  Future fetchDataFromUrl(String section, String category) async {
    isLoading(true);
    try {
      var list =
          await CategoryBranWallRemoteServices.fetchData(section, category);
      imageList.value = list.categoryWall!.images!;

      imageList
        ..sort((a, b) =>
            int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}
