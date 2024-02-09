import 'package:buffywalls/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:buffywalls/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/service_export.dart';
import '../ui/views/view_export.dart';
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: StartupView),
  MaterialRoute(page: NavigationView, children: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: CategoryView),
  ]),
  MaterialRoute(page: FavouriteView),
  CustomRoute(
    page: CommonView,
    transitionsBuilder: TransitionsBuilders.fadeIn,
  ),
// @stacked-route
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: ApiService),
  LazySingleton(classType: NavigationViewModel),
  LazySingleton(classType: HomeViewModel),
  // LazySingleton(classType: CategoryViewModel),
  // LazySingleton(classType: FavouriteViewModel),
  // @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: NoticeSheet),
  // @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
  // @stacked-dialog
], logger: StackedLogger())
class App {}
