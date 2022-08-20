class CategoryBrandModel {
  List<CategoryBrand>? category;

  CategoryBrandModel({this.category});

  CategoryBrandModel.fromJson(Map<String, dynamic> json, String section) {
    if (json[section] is List) {
      category = json[section] == null
          ? null
          : (json[section] as List)
              .map((e) => CategoryBrand.fromJson(e))
              .toList();
    }
  }
}

class CategoryBrand {
  String? name;
  String? imageUrl;
  int? id;

  CategoryBrand({this.name, this.imageUrl, this.id});

  CategoryBrand.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) name = json["name"];
    if (json["imageUrl"] is String) imageUrl = json["imageUrl"];
    if (json["id"] is int) id = json["id"];
  }
}


class Featured {
    Featured({
        this.featured,
    });

    List<FeaturedElement>? featured;

    factory Featured.fromJson(Map<String, dynamic> json) => Featured(
        featured: List<FeaturedElement>.from(json["Featured"].map((x) => FeaturedElement.fromJson(x))),
    );
}

class FeaturedElement {
    FeaturedElement({
        this.redirectUrl,
        this.id,
        this.imageUrl,
    });

    String? redirectUrl;
    int? id;
    String? imageUrl;

    factory FeaturedElement.fromJson(Map<String, dynamic> json) => FeaturedElement(
        redirectUrl: json["redirectUrl"],
        id: json["id"],
        imageUrl: json["imageUrl"],
    );
}
