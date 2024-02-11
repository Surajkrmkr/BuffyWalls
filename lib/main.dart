import 'package:flutter/material.dart';
import 'package:buffywalls/app/app.bottomsheets.dart';
import 'package:buffywalls/app/app.dialogs.dart';
import 'package:buffywalls/app/app.locator.dart';
import 'package:buffywalls/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'services/service_export.dart';
import 'ui/common/common_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await setupLocator();
  await ThemeManager.initialise();
  await locator<SharedPrefService>().onInit();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
        defaultThemeMode: ThemeMode.light,
        darkTheme: darkTheme,
        lightTheme: lightTheme,
        statusBarColorBuilder: (theme) =>
            theme!.colorScheme.background.withOpacity(0),
        navigationBarColorBuilder: (theme) =>
            theme!.colorScheme.background.withOpacity(0),
        builder: (context, regularTheme, darkTheme, themeMode) {
          return MaterialApp(
            theme: regularTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            title: 'BuffyWalls',
            initialRoute: Routes.startupView,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorKey: StackedService.navigatorKey,
            navigatorObservers: [
              StackedService.routeObserver,
            ],
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
