import 'package:flutter/material.dart';

import '../functions/persistence.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = DarkModePersistenceService().savedDarkMode();

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    DarkModePersistenceService().saveThemeMode(value);
    notifyListeners();
  }

  bool _amoledTheme = DarkModePersistenceService().savedAmoledMode();

  bool get amoledTheme => _amoledTheme;

  set amoledTheme(bool value) {
    _amoledTheme = value;
    DarkModePersistenceService().saveAmoledMode(value);
    notifyListeners();
  }


}
