import 'package:flutter_dotenv/flutter_dotenv.dart';

class BuffyService {
  static bool isPro =
      (dotenv.env['BUFFY'] as String == dotenv.env["PAID"] as String);
}
