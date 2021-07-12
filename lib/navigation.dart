import 'package:buffywalls/pages/brand_page.dart';
import 'package:buffywalls/pages/category_page.dart';
import 'package:buffywalls/pages/setup_page.dart';
import 'package:buffywalls/pages/home_screen.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedItemPos = 0.obs;

  var pages = [
    HomePage(),
    SetupPage(),
    CategoryPage(),
    BrandPage(),
  ].obs;

  changeIndex(i) {
    selectedItemPos.value = i;
  }
}
