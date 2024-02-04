import 'package:flutter/material.dart';
import 'package:buffywalls/app/app.bottomsheets.dart';
import 'package:buffywalls/app/app.dialogs.dart';
import 'package:buffywalls/app/app.locator.dart';
import 'package:buffywalls/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'ui/common/common_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await ThemeManager.initialise();
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
        statusBarColorBuilder: (theme) => theme!.colorScheme.background,
        navigationBarColorBuilder: (theme) => theme!.colorScheme.background,
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
