import 'dart:convert';

class HouseEntities {
  final int id;
  final String name;
  final String description;
  // final String? bookingId;

  HouseEntities({
    required this.id,
    required this.name,
    required this.description,
    // this.bookingId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({"id": id});
    result.addAll({"name": name});
    result.addAll({"description": description});
    // result.addAll({"bookingId": bookingId});

    return result;
  }

  factory HouseEntities.fromMap(Map<String, dynamic> map) {
    return HouseEntities(
      id: map["id"]?.toInt() ?? 0,
      name: map["name"] ?? '',
      description: map["description"] ?? '',
      //  bookingId: map["bookingId"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  // @override
  // String toString() {
  //   return 'HouseEntities{id: $id, name: $name, description: $description, bookingId: $bookingId}';
  // }

  factory HouseEntities.fromJson(String source) =>
      HouseEntities.fromMap(json.decode(source));
}
