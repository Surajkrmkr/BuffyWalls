import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';

class ScreenSecurityService {
  static const MethodChannel _channel =
      MethodChannel('com.shadowteam.buffywalls/security');

  // Debug-only: --dart-define=ALLOW_SCREENSHOTS=true leaves FLAG_SECURE off
  // so the detail page can be captured while developing.
  static const bool _allowScreenshots =
      bool.fromEnvironment('ALLOW_SCREENSHOTS');

  static Future<void> enableSecure() async {
    if (kDebugMode && _allowScreenshots) return;
    try {
      await _channel.invokeMethod('enableSecure');
    } catch (_) {}
  }

  static Future<void> disableSecure() async {
    try {
      await _channel.invokeMethod('disableSecure');
    } catch (_) {}
  }
}
