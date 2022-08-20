import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';

import '../theme/ui_color.dart';

class PaletteGeneratorProvider extends ChangeNotifier {
  PaletteGenerator? paletteGenerator;
  var color = [];
  var isLoading = true;
  getIsLoading() => isLoading;
  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  getColorPalette(url) async {
    setIsLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(url),
      maximumColorCount: 7,
    );
    color = paletteGenerator!.colors.toList();
    setIsLoading(false);
  }

  getChip(BuildContext context, int index, dynamic paletteGeneratorProvider) {
    String code =
        paletteGeneratorProvider.color[index].toString().substring(10, 16);
    return ActionChip(
      label: Text("#${code.toUpperCase()}",
          style: GoogleFonts.lato(
              color: Uicolor.whiteColor,
              fontSize: 12,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Uicolor.blackColor.withOpacity(0.6),
                  offset: const Offset(1, 1),
                )
              ])),
      backgroundColor: paletteGeneratorProvider.color[index],
      onPressed: () {
        Clipboard.setData(ClipboardData(text: code));
        MySnackBar.wallSnackBar(context, "Color #$code has been copied");
      },
    );
  }
}
