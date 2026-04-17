import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';

class ThemeDialogModel extends BaseViewModel {
  ThemeMode themeMode = ThemeMode.system;
  final _navigationService = locator<NavigationService>();

  void getThemeMode() {
    themeMode = ThemeManager.instance.selectedThemeMode;
  }

  void setThemeMode(ThemeMode? mode) {
    ThemeManager.instance.setThemeMode(mode ?? ThemeMode.system);
    _navigationService.back();
  }
}
