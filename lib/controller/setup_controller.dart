import 'package:buffywalls/services/setup.dart';
import 'package:get/get.dart';

class SetupController extends GetxController {
  var isSetupLoading = true.obs;

  var setupImageList = [].obs;
  @override
  onInit() {
    fetchDataFromUrl();
    super.onInit();
  }

  Future fetchDataFromUrl() async {
    isSetupLoading(true);
    try {
      var list = await SetupPageServices.fetchData();
      setupImageList.value = list.setup!;

      setupImageList
        ..sort((a, b) =>
            int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      isSetupLoading(false);
    }
  }
}
