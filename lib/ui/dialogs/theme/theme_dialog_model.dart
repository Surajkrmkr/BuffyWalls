import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';

class ThemeDialogModel extends BaseViewModel {
  late BuildContext context;
  ThemeMode themeMode = ThemeMode.system;
  final _navigationService = locator<NavigationService>();

  ThemeDialogModel(this.context);

  void getThemeMode() {
    themeMode = getThemeManager(context).selectedThemeMode ?? ThemeMode.system;
  }

  void setThemeMode(ThemeMode? mode) {
    getThemeManager(context).setThemeMode(mode ?? ThemeMode.system);
    _navigationService.back();
  }
}
