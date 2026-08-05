import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app/app.export.dart';
import 'app/app.package.export.dart';
import 'services/service_export.dart';
import 'ui/common/common_export.dart';
import 'ui/widgets/widget_export.dart';

Future<void> main() async {
  await initializationHandler();
  runApp(LiquidGlassWidgets.wrap(child: const MainApp()));
}

Future<void> initializationHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Parallelize primary setups
  await Future.wait([
    LiquidGlassWidgets.initialize(),
    dotenv.load(isOptional: true, mergeWith: Platform.environment),
    setupLocator(),
  ]);

  // Firebase must be fully ready before anything that touches it —
  // NotificationService uses FirebaseMessaging internally, so it can't
  // run in the same Future.wait as Firebase.initializeApp(): both futures
  // would start concurrently, and NotificationService could (and did)
  // reach FirebaseMessaging.instance before initializeApp() resolved,
  // throwing "No Firebase App '[DEFAULT]' has been created".
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  // These don't depend on each other or on Firebase, so they can still
  // run in parallel — just after Firebase is ready.
  await Future.wait([
    NotificationService().init(),
    ThemeManager.initialise(),
    locator<SharedPrefService>().onInit(),
  ]);

  setupDialogUi();
  setupBottomSheetUi();
  // Ads disabled
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          builder: (context, child) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return BuffyError(errorDetails: errorDetails);
            };
            return child!;
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          title: 'BuffyWalls',
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
            FirebaseAnalyticsObserver(
                analytics: AnalyticsService.instance.observer),
          ],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
