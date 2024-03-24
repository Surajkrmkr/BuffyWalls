import 'package:buffywalls/app/app.export.dart';

import '../app/app.package.export.dart';
import 'service_export.dart';

class BuffyService {
  static bool isPro =
      (dotenv.env['BUFFY'] as String == dotenv.env["PAID"] as String);

  static bool isInitialized = locator<SharedPrefService>().getInitialised();
}
