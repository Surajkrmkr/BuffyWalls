import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

import '../functions/wall_action.dart';
import '../theme/dark_theme.dart';
import '../theme/ui_color.dart';

class SetWallDialog extends StatelessWidget {
  const SetWallDialog({Key? key, @required this.url}) : super(key: key);
  final String? url;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
          ? Uicolor.blackColor
          : Theme.of(context).backgroundColor,
      // title: 'Set Wallpaper',
      // titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          runSpacing: 5,
          children: [
            setWallBtn(
                context: context,
                text: 'Homescreen',
                onPressed: () {
                  try {
                    WallpaperAction.setWall(
                        url: url, type: WallpaperManagerFlutter.HOME_SCREEN);
                    Navigator.pop(context);
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper set successfully');
                  } on Exception {
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper could not be set');
                  }
                }),
            setWallBtn(
                context: context,
                text: 'Lockscreen',
                onPressed: () {
                  try {
                    WallpaperAction.setWall(
                        url: url, type: WallpaperManagerFlutter.LOCK_SCREEN);
                    Navigator.pop(context);
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper set successfully');
                  } on Exception {
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper could not be set');
                  }
                }),
            setWallBtn(
                context: context,
                text: 'Both',
                onPressed: () {
                  try {
                    WallpaperAction.setWall(
                        url: url, type: WallpaperManagerFlutter.BOTH_SCREENS);
                    Navigator.pop(context);
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper set successfully');
                  } on Exception {
                    MySnackBar.wallSnackBar(
                        context, 'Wallpaper could not be set');
                  }
                }),
          ],
        ),
      ),
    );
  }

  SizedBox setWallBtn(
      {BuildContext? context, String? text, Function()? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20)),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context!).primaryColorDark),
            foregroundColor: MaterialStateProperty.all(Uicolor.whiteColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
          ),
          onPressed: onPressed,
          child: Text(
            text!,
            style: MyTextStyle.bottomSheetTextStyleWithDefaultSize(),
          )),
    );
  }
}
