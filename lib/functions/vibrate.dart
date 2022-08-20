import 'package:flutter/services.dart';

class Vibrate{
  static vibrate() => HapticFeedback.lightImpact();
}
