import 'package:movix/Model/base_model.dart';

//* Movie List
class CastPage extends BaseModel {
  ///Properties
  int id;
  List<Cast> cast;

  CastPage();

  @override
  BaseModel createNew() {
    return CastPage();
  }

  @override
  CastPage.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    if (json['cast'] != null) {
      this.cast =
          new List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x)));
    } else {
      this.cast = [];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  CastPage fromJson(Map<String, dynamic> map) {
    return CastPage.fromJson(map);
  }
}

//* Cast
class Cast extends BaseModel {
  ///Properties
  int castId;
  String character;
  int id;
  String name;
  String profilePath;

  Cast();

  @override
  BaseModel createNew() {
    return Cast();
  }

  @override
  Cast.fromJson(Map<String, dynamic> json) {
    this.castId = json["cast_id"] ?? 0;
    this.character = json["character"] ?? 0;
    this.id = json["id"] ?? 0;
    this.name = json["name"] ?? "";
    this.profilePath = json["profile_path"] ?? "";
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  Cast fromJson(Map<String, dynamic> map) {
    return Cast.fromJson(map);
  }
}
