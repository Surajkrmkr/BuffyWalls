class HomePageModel {
  List<HomePageImage>? categoryImages;

  HomePageModel({this.categoryImages});

  HomePageModel.fromJson(Map<String, dynamic> json, String section) {
    if (json[section] is List)
      this.categoryImages = json[section] == null
          ? null
          : (json[section] as List)
              .map((e) => HomePageImage.fromJson(e))
              .toList();
  }
}

class HomePageImage {
  String? heroId;
  int? downloads;
  String? imageUrl;
  String? designer;
  int? id;
  String? compressUrl;
  String? size;
  String? name;
  String? category;

  HomePageImage(
      {this.heroId,
      this.downloads,
      this.imageUrl,
      this.designer,
      this.id,
      this.compressUrl,
      this.size,
      this.name,
      this.category});

  HomePageImage.fromJson(Map<String, dynamic> json) {
    if (json["heroID"] is String) this.heroId = json["heroID"];
    if (json["downloads"] is int) this.downloads = json["downloads"];
    if (json["imageUrl"] is String) this.imageUrl = json["imageUrl"];
    if (json["designer"] is String) this.designer = json["designer"];
    if (json["id"] is int) this.id = json["id"];
    if (json["compressUrl"] is String) this.compressUrl = json["compressUrl"];
    if (json["size"] is String) this.size = json["size"];
    if (json["name"] is String) this.name = json["name"];
    if (json["category"] is String) this.category = json["category"];
  }
}
