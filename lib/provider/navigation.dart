import 'package:flutter/material.dart';

import '../pages/brand_page.dart';
import '../pages/category_page.dart';
import '../pages/home_page.dart';
import '../pages/setup_page.dart';

class NavigationProvider extends ChangeNotifier {
  int selectedItemPos = 0;

  var pages = [
    HomePage(),
    const SetupPage(),
    const CategoryPage(),
    const BrandPage(),
  ];

  getSelectedItemPos() => selectedItemPos;

  setSelectedItemPos(int pos) {
    selectedItemPos = pos;
    notifyListeners();
  }
}
