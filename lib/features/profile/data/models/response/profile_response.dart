import 'dart:convert';

import 'package:movemate/features/profile/domain/entities/profile_entity.dart';

class ProfileResponse {
  final ProfileEntity payload;

  ProfileResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory ProfileResponse.fromMap(Map<String, dynamic> map) {
    return ProfileResponse(
      payload: ProfileEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileResponse.fromJson(String source) =>
      ProfileResponse.fromMap(json.decode(source));
}
