import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/persistence.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/theme_data.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

class MyDarkMode extends GetxController {
  var isDark = DarkModePersistenceService().savedDarkMode().obs;

  switchDarkMode(bool value) {
    isDark.value = value;
    DarkModePersistenceService().saveThemeMode(value);
    // Get.changeTheme(isDark.value? darkTheme() : lightTheme());
  }
}

class DarkModeTile extends StatelessWidget {
  const DarkModeTile({
    @required this.myDarkMode,
    @required this.navigationController,
  }) ;

  final MyDarkMode? myDarkMode;
  final NavigationController? navigationController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        MyFlutterApp.darkmode,
        color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
        size: 25,
      ),
      onTap: () {
        if (myDarkMode!.isDark.value) {
          myDarkMode!.switchDarkMode(false);
          EasyDynamicTheme.of(context)
              .changeTheme(dark: myDarkMode!.isDark.value);
          Phoenix.rebirth(context);
          navigationController!.changeIndex(0);
        } else {
          myDarkMode!.switchDarkMode(true);
          EasyDynamicTheme.of(context)
              .changeTheme(dark: myDarkMode!.isDark.value);
          Phoenix.rebirth(context);
          navigationController!.changeIndex(0);
        }
      },
      trailing: Switch(
        value: myDarkMode!.isDark.value,
        onChanged: (i) {
          myDarkMode!.switchDarkMode(i);
          EasyDynamicTheme.of(context)
              .changeTheme(dark: myDarkMode!.isDark.value);
          // getSnackbar('title', 'message');
          Phoenix.rebirth(context);
          navigationController!.changeIndex(0);
          // Restart.restartApp();
        },
      ),
      title: Text(
        'Dark Mode',
        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      ),
      // subtitle: Text(
      //   'Beast Mode needs to be off',
      //   style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      // ),
    );
  }
}
