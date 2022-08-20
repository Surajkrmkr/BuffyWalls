import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/setup.dart';

class SetupPageServices {
  static Future<SetupModel> fetchData() async {
    String url = "https://surajkrmkr.github.io/BuffyJson/data/setup.json";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return SetupModel.fromJson(json.decode(response.body));
      } else {
        return SetupModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
