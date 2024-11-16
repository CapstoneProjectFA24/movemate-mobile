import 'dart:convert';

import 'package:movemate/models/token_model.dart';

class AccountEntities {
  final int id;
  final String email;
  final String roleName;
  final int? roleId;
  final String? name;
  final String? phone;
  final String? gender;
  final String? avatarUrl;
  final TokenModel tokens;

  AccountEntities({
    required this.id,
    required this.email,
    required this.roleName,
    required this.tokens,
    this.roleId,
    this.name,
    this.phone,
    this.gender,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'roleName': roleName});
    if (roleId != null) result.addAll({'roleId': roleId});
    if (name != null) result.addAll({'name': name});
    if (phone != null) result.addAll({'phone': phone});
    if (gender != null) result.addAll({'gender': gender});
    if (avatarUrl != null) result.addAll({'avatarUrl': avatarUrl});
    result.addAll({'tokens': tokens.toMap()});

    return result;
  }

  factory AccountEntities.fromMap(Map<String, dynamic> map) {
    return AccountEntities(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      roleName: map['roleName'] ?? '',
      roleId: map['roleId'] ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      tokens: TokenModel.fromMap(map['tokens']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountEntities.fromJson(String source) =>
      AccountEntities.fromMap(json.decode(source));
}
