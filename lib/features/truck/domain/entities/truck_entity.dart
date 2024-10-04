import 'dart:convert';

class TruckEntity {
  final int id;
  final String name;
  final String description;

  TruckEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({"id": id});
    result.addAll({"name": name});
    result.addAll({"description": description});

    return result;
  }

  factory TruckEntity.fromMap(Map<String, dynamic> map) {
    return TruckEntity(
      id: map["id"]?.toInt() ?? 0,
      name: map["name"] ?? '',
      description: map["description"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TruckTest(id: $id)';
  }

  factory TruckEntity.fromJson(String source) =>
      TruckEntity.fromMap(json.decode(source));
}
