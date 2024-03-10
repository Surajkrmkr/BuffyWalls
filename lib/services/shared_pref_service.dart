import '../app/app.package.export.dart';

class SharedPrefService {
  late SharedPreferences prefs;

  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
  }
}
