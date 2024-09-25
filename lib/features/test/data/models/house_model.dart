import 'dart:convert';

class HouseModel {

    final int id;
  final String name;
  final String description;
  final String? bookingId;

  HouseModel({
    required this.id,
    required this.name,
    required this.description,
    this.bookingId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({"id": id});
    result.addAll({"name": name});
    result.addAll({"description": description});
    result.addAll({"bookingId": bookingId});

    return result;
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map["id"]?.toInt() ?? 0,
      name: map["name"] ?? '',
      description: map["description"] ?? '',
      bookingId: map["bookingId"].toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) =>
      HouseModel.fromMap(json.decode(source));
}
