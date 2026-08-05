// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/about/about_dialog.dart';
import '../ui/dialogs/cache/cache_dialog.dart';
import '../ui/dialogs/changelog/changelog_dialog.dart';
import '../ui/dialogs/pro/pro_dialog.dart';
import '../ui/dialogs/theme/theme_dialog.dart';

enum DialogType {
  theme,
  cache,
  changelog,
  about,
  pro,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.theme: (context, request, completer) =>
        ThemeDialog(request: request, completer: completer),
    DialogType.cache: (context, request, completer) =>
        CacheDialog(request: request, completer: completer),
    DialogType.changelog: (context, request, completer) =>
        ChangelogDialog(request: request, completer: completer),
    DialogType.about: (context, request, completer) =>
        AboutDialog(request: request, completer: completer),
    DialogType.pro: (context, request, completer) =>
        ProDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
