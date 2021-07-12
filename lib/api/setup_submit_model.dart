class SubmitForm {
  String author;
  String authorLink;
  String image;
  String imageLink;
  String kwgt;
  String kwgtLink;
  String launcher;
  String launcherLink;
  String iconpack;
  String iconpackLink;
  String name;
  String setupImageLink;

  SubmitForm(
      this.author,
      this.authorLink,
      this.image,
      this.imageLink,
      this.kwgt,
      this.kwgtLink,
      this.launcher,
      this.launcherLink,
      this.iconpack,
      this.iconpackLink,
      this.name,
      this.setupImageLink);

  factory SubmitForm.fromJson(dynamic json) {
    return SubmitForm(
        "${json['author']}",
        "${json['authorLink']}",
        "${json['image']}",
        "${json['imageLink']}",
        "${json['kwgt']}",
        "${json['kwgtLink']}",
        "${json['launcher']}",
        "${json['launcherLink']}",
        "${json['iconpack']}",
        "${json['iconpackLink']}",
        "${json['name']}",
        "${json['setupImageLink']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'author': author,
        'authorLink': authorLink,
        'image': image,
        'imageLink': imageLink,
        'kwgt': kwgt,
        'kwgtLink': kwgtLink,
        'launcher': launcher,
        'launcherLink': launcherLink,
        'iconpack': iconpack,
        'iconpackLink': iconpackLink,
        'name': name,
        'setupImageLink': setupImageLink
      };
}
