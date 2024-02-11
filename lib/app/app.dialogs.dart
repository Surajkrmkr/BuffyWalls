// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/cache/cache_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/theme/theme_dialog.dart';

enum DialogType {
  infoAlert,
  theme,
  cache,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.theme: (context, request, completer) =>
        ThemeDialog(request: request, completer: completer),
    DialogType.cache: (context, request, completer) =>
        CacheDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
