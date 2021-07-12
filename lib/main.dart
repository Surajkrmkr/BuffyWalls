import 'package:buffywalls/home.dart';
import 'package:buffywalls/theme/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(Phoenix(child: EasyDynamicThemeWidget(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BuffyWalls',
      themeMode: EasyDynamicTheme.of(context).themeMode!,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: Home(),
    );
  }
}


//Splash command
// flutter pub run flutter_native_splash:create

//package name command
// flutter pub run change_app_package_name:main com.shadowteam.buffywallspaid
// flutter pub run change_app_package_name:main com.shadowteam.buffywallsfree

//app version
//pro - 1.0.2+3
//free - 1.0.7+8