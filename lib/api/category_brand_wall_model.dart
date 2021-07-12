class CategorizedWallModel {
  CategorizedWall? categoryWall;

  CategorizedWallModel({this.categoryWall});

  CategorizedWallModel.fromJson(Map<String, dynamic> json, String name) {
    if (json[name] is Map)
      this.categoryWall =
          json[name] == null ? null : CategorizedWall.fromJson(json[name]);
  }
}

class CategorizedWall {
  List<ImagesWall>? images;

  CategorizedWall({this.images});

  CategorizedWall.fromJson(Map<String, dynamic> json) {
    if (json["Images"] is List)
      this.images = json["Images"] == null
          ? null
          : (json["Images"] as List)
              .map((e) => ImagesWall.fromJson(e))
              .toList();
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

  ImagesWall(
      {this.downloads,
      this.id,
      this.imageUrl,
      this.compressUrl,
      this.designer,
      this.name,
      this.heroId,
      this.size});

  ImagesWall.fromJson(Map<String, dynamic> json) {
    if (json["downloads"] is int) this.downloads = json["downloads"];
    if (json["id"] is int) this.id = json["id"];
    if (json["imageUrl"] is String) this.imageUrl = json["imageUrl"];
    if (json["compressUrl"] is String) this.compressUrl = json["compressUrl"];
    if (json["designer"] is String) this.designer = json["designer"];
    if (json["name"] is String) this.name = json["name"];
    if (json["heroID"] is String) this.heroId = json["heroID"];
    if (json["size"] is String) this.size = json["size"];
  }
}
