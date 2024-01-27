import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuffySvgs {
  static SvgPicture icon({required String path, required Color color}) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
