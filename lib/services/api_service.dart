import 'dart:convert';

import 'package:buffywalls/app/app.logger.dart';
import 'package:dio/dio.dart';

import '../models/model_export.dart';

class ApiService {
  final logger = getLogger('ApiService');
  BuffyWallsModel? model;

  Future<BuffyWallsModel> getWalls() async {
    final client = Dio();
    const url =
        'https://gitlab.com/teamshadowsupp/buffywallsjson/-/raw/main/buffy.json';
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
}
