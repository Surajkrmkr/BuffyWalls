class CategoryBrandModel {
  List<CategoryBrand>? category;

  CategoryBrandModel({this.category});

  CategoryBrandModel.fromJson(Map<String, dynamic> json,String section) {
    if (json[section] is List)
      this.category = json[section] == null
          ? null
          : (json[section] as List)
              .map((e) => CategoryBrand.fromJson(e))
              .toList();
  }
}

class CategoryBrand {
  String? name;
  String? imageUrl;
  int? id;

  CategoryBrand({this.name, this.imageUrl, this.id});

  CategoryBrand.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) this.name = json["name"];
    if (json["imageUrl"] is String) this.imageUrl = json["imageUrl"];
    if (json["id"] is int) this.id = json["id"];
  }
}
