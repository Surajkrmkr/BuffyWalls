import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/category_brand.dart';
import '../model/trending_popular.dart';

class HomePageRemoteServices {
  static Future<HomePageModel> fetchData(String section) async {
    String url = "https://surajkrmkr.github.io/BuffyJson/data/$section.json";
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
  static Future<Featured> fetchFeatureData(String section) async {
    String url = "https://surajkrmkr.github.io/BuffyJson/data/$section.json";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return Featured.fromJson(json.decode(response.body));
      } else {
        return Featured();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
