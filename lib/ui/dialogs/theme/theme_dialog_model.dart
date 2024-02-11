import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../../app/app.locator.dart';

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
