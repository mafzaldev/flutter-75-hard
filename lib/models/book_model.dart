class BookModel {
  String? title;
  List<String>? authors;
  String? description;
  ImageLinks? imageLinks;

  BookModel({this.title, this.authors, this.description, this.imageLinks});

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    authors = json.containsKey('authors') ? json['authors'].cast<String>() : [];
    description = json['description'];
    imageLinks = json['imageLinks'] != null
        ? ImageLinks.fromJson(json['imageLinks'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['authors'] = authors;
    data['description'] = description;
    if (imageLinks != null) {
      data['imageLinks'] = imageLinks!.toJson();
    }
    return data;
  }
}

class ImageLinks {
  String? smallThumbnail;

  ImageLinks({this.smallThumbnail});

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['smallThumbnail'] = smallThumbnail;
    return data;
  }
}
