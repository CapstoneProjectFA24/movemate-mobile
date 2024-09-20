import 'dart:convert';
import 'token_model.dart';
import 'user_token.dart';

class UserModel {
  final int? id;
  final String email;
  final TokenModel tokens;
  final String? fcmToken;
  final List<UserDevice>? userTokens;

  UserModel({
    required this.id,
    required this.email,
    required this.tokens,
    this.fcmToken,
    this.userTokens,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }

    result.addAll({'email': email});
    result.addAll({'tokens': tokens.toMap()});
    if (fcmToken != null) {
      result.addAll({'fcmToken': fcmToken});
    }
    if (userTokens != null) {
      result.addAll({'userTokens': userTokens!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      email: map['email'] ?? '',
      tokens: TokenModel.fromMap(map['tokens']),
      fcmToken: map['fcmToken'],
      userTokens: map['userTokens'] != null
          ? List<UserDevice>.from(
              map['userTokens']?.map((x) => UserDevice.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    int? id,
    String? email,
    TokenModel? tokens,
    String? fcmToken,
    List<UserDevice>? userTokens,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      tokens: tokens ?? this.tokens,
      fcmToken: fcmToken ?? this.fcmToken,
      userTokens: userTokens ?? this.userTokens,
    );
  }
}
