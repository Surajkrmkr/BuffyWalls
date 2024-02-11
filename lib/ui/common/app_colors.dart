import 'package:flutter/material.dart';

const Color backgroundDark = Color(0xFF02081C);
const Color backgroundLight = Colors.white;

const Color foregroundLight = Colors.black;
const Color foregroundDark = Colors.white;

const Color transparent = Colors.transparent;

const Color primary = Color(0xFF161630);
const Color secondary = Colors.grey;
const Color accent = Colors.black;
const Color error = Colors.red;

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
      return Colors.deepOrangeAccent;
    }
    return Colors.black;
  }
}
