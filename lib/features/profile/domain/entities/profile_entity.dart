import 'dart:convert';

class ProfileEntity {
  final int id;

  ProfileEntity({
    required this.id,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({"id": id});

    return result;
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      id: map["id"]?.toInt() ?? 0,
    );
  }
  String toJson() => json.encode(toMap());

  factory ProfileEntity.fromJson(String source) =>
      ProfileEntity.fromMap(json.decode(source));
}
