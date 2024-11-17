import 'dart:convert';

import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';

class StaffProfileResponse {
  final StaffProfileEntity payload;

  StaffProfileResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory StaffProfileResponse.fromMap(Map<String, dynamic> map) {
    return StaffProfileResponse(
      payload: StaffProfileEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffProfileResponse.fromJson(String source) =>
      StaffProfileResponse.fromMap(json.decode(source));
}
