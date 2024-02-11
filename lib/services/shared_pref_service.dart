import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  late SharedPreferences prefs;

  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
  }
}
