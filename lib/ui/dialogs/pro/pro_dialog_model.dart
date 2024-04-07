import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';

class ProDialogModel extends BaseViewModel {
  void onGetProTapped() => launchUrl(Uri.parse(Links.devPage),
      mode: LaunchMode.externalNonBrowserApplication);
}
