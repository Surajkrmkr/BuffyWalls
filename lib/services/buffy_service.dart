import '../app/app.package.export.dart';

class BuffyService {
  static bool isPro =
      (dotenv.env['BUFFY'] as String == dotenv.env["PAID"] as String);
}
