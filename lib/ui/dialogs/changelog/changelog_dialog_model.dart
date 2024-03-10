import 'package:flutter/services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';

class ChangelogDialogModel extends FutureViewModel {
  final _navigationService = locator<NavigationService>();

  @override
  Future<List<String>> futureToRun() async {
    final String fileAsString =
        await rootBundle.loadString(Links.locaChangelogPath);
    final changeLogs = fileAsString.split('\n');
    return changeLogs.map((e) => e.trim()).toList();
  }

  void onGotItTapped() => _navigationService.back();
}
