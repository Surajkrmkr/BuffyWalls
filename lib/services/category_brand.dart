import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/category_brand.dart';

class CategoryBrandRemoteServices {
  static Future<CategoryBrandModel> fetchData(String section) async {
    String url = "https://surajkrmkr.github.io/BuffyJson/data/$section.json";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return CategoryBrandModel.fromJson(json.decode(response.body), section);
      } else {
        return CategoryBrandModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
