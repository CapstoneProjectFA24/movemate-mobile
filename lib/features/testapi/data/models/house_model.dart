import 'dart:convert';

class HouseModel {
  final int? id;
  final String? name;

  HouseModel({this.id, this.name});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({"id": id});
    result.addAll({"name": name});

    return result;
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map["id"]?.toInt() ?? 0,
      name: map["name"] ?? '',
    );
  }
  @override
  String toString() => json.encode(toMap());

  //
  factory HouseModel.fromJson(String source) => HouseModel.fromMap(
        json.decode(source),
      );
}
