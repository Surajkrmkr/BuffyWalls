import 'package:buffywalls/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/service_export.dart';
import '../ui/views/view_export.dart';
import 'package:buffywalls/ui/dialogs/theme/theme_dialog.dart';
import 'package:buffywalls/ui/dialogs/cache/cache_dialog.dart';
import 'package:buffywalls/ui/dialogs/changelog/changelog_dialog.dart';
import 'package:buffywalls/ui/dialogs/about/about_dialog.dart';
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: StartupView),
  MaterialRoute(page: NavigationView, children: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: CategoryView),
    MaterialRoute(page: FavouriteView),
  ]),
  MaterialRoute(page: CommonView),
  MaterialRoute(page: SettingsView),
  MaterialRoute(page: ImageView),
  MaterialRoute(page: SearchView),
  MaterialRoute(page: OnboardView),
// @stacked-route
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: ApiService),
  LazySingleton(classType: AdsService),
  LazySingleton(classType: SharedPrefService),
  LazySingleton(classType: BuffyService),
  LazySingleton(classType: NavigationViewModel),
  LazySingleton(classType: HomeViewModel),
  LazySingleton(classType: CategoryViewModel),
  LazySingleton(classType: FavouriteViewModel),
  // @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: NoticeSheet),
  // @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: ThemeDialog),
  StackedDialog(classType: CacheDialog),
  StackedDialog(classType: ChangelogDialog),
  StackedDialog(classType: AboutDialog),
// @stacked-dialog
], logger: StackedLogger())
class App {}
