import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buffywalls_3/functions/routes.dart';
import 'package:buffywalls_3/my_providers.dart';
import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/theme/theme_data.dart';
import 'package:buffywalls_3/widgets/pro_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'functions/persistence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  if (!ProDialog.appIsPro) MobileAds.instance.initialize();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'buffy_channel_group',
            channelKey: 'rating',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            ledColor: Colors.white),
        NotificationChannel(
            channelGroupKey: 'buffy_channel_group',
            channelKey: 'download',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            ledColor: Colors.white)
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MyProviders.providers,
      child: Consumer<DarkThemeProvider>(
          builder: (context, darkThemeProvider, child) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: darkThemeProvider.amoledTheme
                ? Brightness.light
                : darkThemeProvider.darkTheme
                    ? Brightness.light
                    : Brightness.dark,
            statusBarBrightness: darkThemeProvider.amoledTheme
                ? Brightness.light
                : darkThemeProvider.darkTheme
                    ? Brightness.light
                    : Brightness.dark));
        return MaterialApp(
          title: ProDialog.appIsPro ? 'BuffyWalls Pro' : 'BuffyWalls',
          theme: ThemeDataStyle.themeData(darkThemeProvider.darkTheme, context),
          routes: MyRoutes().getRoutes(context),
          initialRoute:
              !RatingNotification().savedRatingNotify() ? '/onBoard' : '/',
        );
      }),
    );
  }
}


//Splash command
// flutter pub run flutter_native_splash:create

//package name command
// flutter pub run change_app_package_name:main com.shadowteam.buffywallspaid
// flutter pub run change_app_package_name:main com.shadowteam.buffywallsfree

//app version - 1.0.11+12