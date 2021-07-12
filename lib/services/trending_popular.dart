import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:buffywalls/api/trending_popular_model.dart';

class HomePageRemoteServices {
  static Future<HomePageModel> fetchData(String section) async {
    String url =
        "https://surajkrmkr.github.io/BuffyJson/data/" + section + ".json";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return HomePageModel.fromJson(json.decode(response.body), section);
      } else {
        return HomePageModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
