import 'package:flutter/material.dart';

const Color backgroundDark = Color(0xFF0B0B0E);
const Color backgroundLight = Color(0xFFF7F5F0);

const Color foregroundLight = Colors.black;
const Color foregroundDark = Colors.white;

const Color transparent = Colors.transparent;

const Color primary = Color(0xFF161630);
const Color secondary = Colors.grey;
const Color accent = Colors.black;
const Color error = Colors.red;

const Color accentGradientStart = Color(0xFFE2B357);
const Color accentGradientEnd = Color(0xFFBB7F2A);

// Single warm gold used for everything premium; ember marks hot/new.
const Color gold = Color(0xFFE2B357);
const Color goldDeep = Color(0xFFBB7F2A);
const Color ember = Color(0xFFFF6A3D);
const Color onGold = Color(0xFF1C1206);
const Color surfaceDark = Color(0xFF15151A);
const Color surfaceLight = Colors.white;
const List<Color> premiumGradient = [accentGradientStart, accentGradientEnd];

extension CapitalizeExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

extension ColorExtension on String {
  Color toColor() {
    if (contains("black")) {
      return Colors.black;
    } else if (contains("red")) {
      return Colors.redAccent;
    } else if (contains("orange")) {
      return Colors.orangeAccent;
    } else if (contains("blue")) {
      return Colors.blueAccent;
    } else if (contains("cyan")) {
      return Colors.cyanAccent;
    } else if (contains("indigo")) {
      return Colors.indigoAccent;
    } else if (contains("green")) {
      return Colors.greenAccent;
    } else if (contains("pink")) {
      return Colors.pinkAccent;
    } else if (contains("purple")) {
      return Colors.deepPurpleAccent;
    } else if (contains("teal")) {
      return Colors.tealAccent;
    } else if (contains("brown")) {
      return Colors.brown;
    } else if (contains("yellow")) {
      return Colors.yellowAccent;
    }
    return Colors.black;
  }
}

extension ColorHex on Color {
  String get toHex => '#${toARGB32().toRadixString(16).padLeft(8, '0')}';
}
