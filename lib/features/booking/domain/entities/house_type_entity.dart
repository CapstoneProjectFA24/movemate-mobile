import 'dart:convert';

class HouseTypeEntity {
  final int? id;
  final String name;
  final String description;
  final bool? isActived;
  final int? bookingId;

  HouseTypeEntity({
    this.id,
    required this.name,
    required this.description,
    this.isActived,
    this.bookingId,
  });

  factory HouseTypeEntity.fromMap(Map<String, dynamic> map) {
    return HouseTypeEntity(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'],
      bookingId: map['bookingId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActived': isActived,
      'bookingId': bookingId,
    };
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return '\nHouseTypeEntity(id: $id,name: $name,description: $description) \n';
  }

  factory HouseTypeEntity.fromJson(String source) =>
      HouseTypeEntity.fromMap(json.decode(source));
}
