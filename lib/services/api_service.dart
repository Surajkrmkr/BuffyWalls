import 'dart:convert';

import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../models/model_export.dart';

class ApiService {
  final logger = getLogger('ApiService');
  BuffyWallsModel? model;

  Future<BuffyWallsModel> getWalls() async {
    final client = Dio();
    final url = dotenv.env['URL'] as String;
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        model = BuffyWallsModel.fromJson(jsonDecode(response.data));
        return model!;
      } else {
        return BuffyWallsModel()..error = "Something went wrong";
      }
    } catch (error) {
      logger.e(error.toString());
      return BuffyWallsModel()..error = "Something went wrong";
    }
  }

  Future<List<String>> getOnboardBanners() async {
    final client = Dio();
    final url = dotenv.env['ONBOARD_URL'] as String;
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data)["banners"] as List;
        return data.map((e) => e as String).toList();
      } else {
        return [];
      }
    } catch (error) {
      logger.e(error.toString());
      return [];
    }
  }
}
