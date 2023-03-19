import 'package:flutter/material.dart';

import '../functions/persistence.dart';

class Uicolor extends ChangeNotifier {
  // static var defaultAccentColor = Color(0xFFFE5C6D).obs;
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;

  Color _defaultAccentColor =
      Color(DarkModePersistenceService().savedAccentColor());

  static Color imageViewBtnColor = const Color(0xFF121212);

  Color get defaultAccentColor => _defaultAccentColor;
  set defaultAccentColor(Color value) {
    _defaultAccentColor = value;
    DarkModePersistenceService().saveAccentColor(_defaultAccentColor.value);
    notifyListeners();
  }

  static const List<Color> accentColors = [
    ...Colors.primaries,
    // ...Colors.accents, Color(0xFFaa00ff)
    // List of Primary Colors
    // Color(0xFFf44336),
    // Color(0xFFe91e63),
    // Color(0xFF9c27b0),
    // Color(0xFF673ab7),
    // Color(0xFF3f51b5),
    // Color(0xFF2196f3),
    // Color(0xFF009688),
    // Color(0xFF4caf50),
    // Color(0xFF8bc34a),
    // Color(0xFFcddc39),
    // Color(0xFFffeb3b),
    // Color(0xFFffc107),
    // Color(0xFFff9800),
    // Color(0xFFff5722),
    // Color(0xFF795548),
    Color(0xFF9e9e9e),
    // Color(0xFF607d8b),
    // Color(0xFF7e57c2),
    // Color(0xFFab47bc),
    Color(0xFFaa00ff)
  ];
}
