import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.export.dart';
import 'app/app.package.export.dart';
import 'services/service_export.dart';
import 'ui/common/common_export.dart';
import 'ui/widgets/widget_export.dart';

Future<void> main() async {
  await initializationHandler();
  runApp(const MainApp());
}

Future<void> initializationHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await FirebaseAppCheck.instance.activate();
  await NotificationService().init();
  await dotenv.load(isOptional: true, mergeWith: Platform.environment);
  await setupLocator();
  await ThemeManager.initialise();
  await locator<SharedPrefService>().onInit();
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
