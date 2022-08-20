import '../widgets/pro_dialog.dart';

class CategorizedWallModel {
  CategorizedWall? categoryWall;

  CategorizedWallModel({this.categoryWall});

  CategorizedWallModel.fromJson(Map<String, dynamic> json, String name) {
    if (json[name] is Map) {
      categoryWall =
          json[name] == null ? null : CategorizedWall.fromJson(json[name]);
    }
  }
}

class CategorizedWall {
  List<ImagesWall>? images;

  CategorizedWall({this.images});

  CategorizedWall.fromJson(Map<String, dynamic> json) {
    if (json["Images"] is List) {
      images = json["Images"] == null
          ? null
          : (json["Images"] as List)
              .map((e) => ImagesWall.fromJson(e))
              .toList();
    }
  }
}

class ImagesWall {
  int? downloads;
  int? id;
  String? imageUrl;
  String? compressUrl;
  String? designer;
  String? name;
  String? heroId;
  String? size;
  bool? isPremium;

  ImagesWall(
      {this.downloads,
      this.id,
      this.imageUrl,
      this.compressUrl,
      this.designer,
      this.name,
      this.heroId,
      this.size,
      this.isPremium});

  ImagesWall.fromJson(Map<String, dynamic> json) {
    if (json["downloads"] is int) downloads = json["downloads"];
    if (json["id"] is int) id = json["id"];
    if (json["imageUrl"] is String) imageUrl = json["imageUrl"];
    if (json["compressUrl"] is String) compressUrl = json["compressUrl"];
    if (json["designer"] is String) designer = json["designer"];
    if (json["name"] is String) name = json["name"];
    if (json["heroID"] is String) heroId = json["heroID"];
    if (json["size"] is String) size = json["size"];
    isPremium = ProDialog.appIsPro ? false : (json["isPremium"] ?? false);
  }
}
