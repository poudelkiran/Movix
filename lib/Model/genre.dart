import 'base_model.dart';


//* Genre List
class GenrePage extends BaseModel {
  ///Properties
  List<Genre> genre;

  GenrePage();

  @override
  BaseModel createNew() {
    return GenrePage();
  }

  @override
  GenrePage.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
     this.genre = new List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)));
    } else {
      this.genre = [];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  GenrePage fromJson(Map<String, dynamic> map) {
    return GenrePage.fromJson(map);
  }
}

//* Genre
class Genre extends BaseModel {
  ///Properties
  int id;
  String name;

  Genre();

  @override
  BaseModel createNew() {
    return Genre();
  }

  @override
  Genre.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  Genre fromJson(Map<String, dynamic> map) {
    return Genre.fromJson(map);
  }
}