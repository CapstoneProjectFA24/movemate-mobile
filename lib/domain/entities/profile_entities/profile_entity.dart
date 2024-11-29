import 'dart:convert';

class ProfileEntity {
  final int id;
  final int roleId;
  final String name;
  final String phone;
  final String password;
  final String gender;
  final String email;
  final String? avatarUrl;
  final String? dob;
  final bool isBanned;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool? isInitUsed;
  final bool isDriver;
  final String? codeIntroduce;
  final int? numberIntroduce;

  ProfileEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.phone,
    required this.password,
    required this.gender,
    required this.email,
    this.avatarUrl,
    this.dob,
    required this.isBanned,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isInitUsed,
    required this.isDriver,
    this.codeIntroduce,
    this.numberIntroduce,
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
      'dob': dob,
      'isBanned': isBanned,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isInitUsed': isInitUsed,
      'isDriver': isDriver,
      'codeIntroduce': codeIntroduce,
      'numberIntroduce': numberIntroduce,
    };
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      id: map['id']?.toInt() ?? 0,
      roleId: map['roleId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      dob: map['dob'],
      isBanned: map['isBanned'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      isInitUsed: map['isInitUsed'],
      isDriver: map['isDriver'] ?? false,
      codeIntroduce: map['codeIntroduce'],
      numberIntroduce: map['numberIntroduce']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileEntity.fromJson(String source) =>
      ProfileEntity.fromMap(json.decode(source));
}
