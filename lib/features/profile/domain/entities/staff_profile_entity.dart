import 'dart:convert';

class StaffProfileEntity {
  final int id;
  final int roleId;
  final String name;
  final String phone;
  final String password;
  final String gender;
  final String email;
  final String? avatarUrl;

  StaffProfileEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.phone,
    required this.password,
    required this.gender,
    required this.email,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roleId': roleId,
      'name': name,
      'phone': phone,
      'password': password,
      'gender': gender,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory StaffProfileEntity.fromMap(Map<String, dynamic> map) {
    return StaffProfileEntity(
      id: map['id']?.toInt() ?? 0,
      roleId: map['roleId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffProfileEntity.fromJson(String source) =>
      StaffProfileEntity.fromMap(json.decode(source));
}
