/// Base model.
abstract class BaseModel {
  int id;
  BaseModel();
  fromJson(Map<String, dynamic> map);
  BaseModel createNew();
  Map<String, dynamic> toJson();
}
