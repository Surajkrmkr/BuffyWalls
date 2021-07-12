import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';

class MyPaletteGeneratorController extends GetxController {
  PaletteGenerator? paletteGenerator;
  var color = [].obs;
  var isLoading = true.obs;
  getColorPalette(url) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(url),
      maximumColorCount: 5,
    );
    color.value = paletteGenerator!.colors.toList();
    isLoading.value = false;
  }

  getChip(int index, dynamic paletteGeneratorController) {
    return ActionChip(
      label: Text("#color_" + (index + 1).toString(),
          style: GoogleFonts.cairo(
            color: Uicolor.whiteColor,
          )),
      backgroundColor: paletteGeneratorController.color[index],
      onPressed: () {
        Clipboard.setData(ClipboardData(
            text: paletteGeneratorController.color[index].toString()));
        getSnackbar("Color", 'has been copied');
      },
    );
  }
}
