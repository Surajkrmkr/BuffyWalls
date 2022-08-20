import '../widgets/pro_dialog.dart';

class HomePageModel {
  List<HomePageImage>? categoryImages;

  HomePageModel({this.categoryImages});

  HomePageModel.fromJson(Map<String, dynamic> json, String section) {
    if (json[section] is List) {
      categoryImages = json[section] == null
          ? null
          : (json[section] as List)
              .map((e) => HomePageImage.fromJson(e))
              .toList();
    }
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
  bool? isPremium;

  HomePageImage(
      {this.heroId,
      this.downloads,
      this.imageUrl,
      this.designer,
      this.id,
      this.compressUrl,
      this.size,
      this.name,
      this.category,
      this.isPremium});

  HomePageImage.fromJson(Map<String, dynamic> json) {
    if (json["heroID"] is String) heroId = json["heroID"];
    if (json["downloads"] is int) downloads = json["downloads"];
    if (json["imageUrl"] is String) imageUrl = json["imageUrl"];
    if (json["designer"] is String) designer = json["designer"];
    if (json["id"] is int) id = json["id"];
    if (json["compressUrl"] is String) compressUrl = json["compressUrl"];
    if (json["size"] is String) size = json["size"];
    if (json["name"] is String) name = json["name"];
    if (json["category"] is String) category = json["category"];
    isPremium = ProDialog.appIsPro ? false : json["isPremium"] ?? false;
  }

  Map toJson() => {
        "heroID": heroId,
        "downloads": downloads,
        "imageUrl": imageUrl,
        "designer": designer,
        "id": id,
        "compressUrl": compressUrl,
        "size": size,
        "name": name,
        "category": category
      };
}
