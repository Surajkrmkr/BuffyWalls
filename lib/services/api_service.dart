import 'dart:convert';

import 'package:flutter/services.dart';

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

  Future<List<String>> _fallbackBanners() async {
    final raw = await rootBundle.loadString('assets/app/onboard_banners.json');
    final data = jsonDecode(raw)["banners"] as List;
    return data.map((e) => e as String).toList();
  }

  Future<List<String>> getOnboardBanners() async {
    final client = Dio();
    final url = dotenv.env['ONBOARD_URL'] as String;
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final body = response.data as String;
        if (body.contains('You cannot access the raw file')) {
          logger.w('ApiService | getOnboardBanners - GitLab rate limited, using fallback');
          return _fallbackBanners();
        }
        final data = jsonDecode(body)["banners"] as List;
        return data.map((e) => e as String).toList();
      }
      return _fallbackBanners();
    } on DioException catch (error) {
      if (error.response?.statusCode == 429) {
        logger.w('ApiService | getOnboardBanners - rate limited (429), using fallback');
        return _fallbackBanners();
      }
      logger.e(error.toString());
      return _fallbackBanners();
    } catch (error) {
      logger.e(error.toString());
      return _fallbackBanners();
    }
  }
}
