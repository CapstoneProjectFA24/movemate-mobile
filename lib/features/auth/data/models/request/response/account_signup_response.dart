import 'dart:convert';

import 'package:movemate/models/token_model.dart';

class AccountReponse {
  final int id;
  final String email;
  final String roleName;
  final TokenModel tokens;

  AccountReponse({
    required this.id,
    required this.email,
    required this.roleName,
    required this.tokens,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'roleName': roleName});
    result.addAll({'tokens': tokens.toMap()});

    return result;
  }

  factory AccountReponse.fromMap(Map<String, dynamic> map) {
    
    return AccountReponse(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      roleName: map['roleName'] ?? '',
      tokens: TokenModel.fromMap(map['tokens']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountReponse.fromJson(String source) =>
      AccountReponse.fromMap(json.decode(source));
}