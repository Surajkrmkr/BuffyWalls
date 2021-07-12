import 'dart:convert';
import 'package:buffywalls/api/category_brand_wall_model.dart';
import 'package:http/http.dart' as http;


class CategoryBranWallRemoteServices {
  static Future<CategorizedWallModel> fetchData(String section,String category) async {
    String url =
        "https://surajkrmkr.github.io/BuffyJson/data/" + section+ '/'+ category +".json";
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        return CategorizedWallModel.fromJson(json.decode(response.body), category);
      } else {
        return CategorizedWallModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
