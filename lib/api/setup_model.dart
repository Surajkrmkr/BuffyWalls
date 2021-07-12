
class SetupModel {
  List<Setup>? setup;

  SetupModel({this.setup});

  SetupModel.fromJson(Map<String, dynamic> json) {
    if(json["setup"] is List)
      this.setup = json["setup"]==null ? null : (json["setup"] as List).map((e)=>Setup.fromJson(e)).toList();
  }
}

class Setup {
  int? id;
  String? name;
  String? setupImageLink;
  String? imageLink;
  String? author;
  String? authorLink;
  String? launcher;
  String? image;
  String? launcherLink;
  String? kwgt;
  String? kwgtLink;
  String? iconpack;
  String? iconpackLink;

  Setup({this.id, this.name, this.setupImageLink, this.imageLink, this.author, this.authorLink, this.launcher, this.image, this.launcherLink, this.kwgt, this.kwgtLink, this.iconpack, this.iconpackLink});

  Setup.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int)
      this.id = json["id"];
    if(json["name"] is String)
      this.name = json["name"];
    if(json["setupImageLink"] is String)
      this.setupImageLink = json["setupImageLink"];
    if(json["imageLink"] is String)
      this.imageLink = json["imageLink"];
    if(json["author"] is String)
      this.author = json["author"];
    if(json["authorLink"] is String)
      this.authorLink = json["authorLink"];
    if(json["launcher"] is String)
      this.launcher = json["launcher"];
    if(json["image"] is String)
      this.image = json["image"];
    if(json["launcherLink"] is String)
      this.launcherLink = json["launcherLink"];
    if(json["kwgt"] is String)
      this.kwgt = json["kwgt"];
    if(json["kwgtLink"] is String)
      this.kwgtLink = json["kwgtLink"];
    if(json["iconpack"] is String)
      this.iconpack = json["iconpack"];
    if(json["iconpackLink"] is String)
      this.iconpackLink = json["iconpackLink"];
  }
}