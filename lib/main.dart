import 'package:flutter/material.dart';

import 'app/app.export.dart';
import 'app/app.package.export.dart';
import 'services/service_export.dart';
import 'ui/common/common_export.dart';

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
  // await NotificationService().init();
  await dotenv.load();
  await setupLocator();
  await ThemeManager.initialise();
  await locator<SharedPrefService>().onInit();
  setupDialogUi();
  setupBottomSheetUi();
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
