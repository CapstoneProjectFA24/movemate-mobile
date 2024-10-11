import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';

class ServicesPackageResponse {
  final List<ServicesPackageEntity> payload;

  ServicesPackageResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ServicesPackageResponse.fromMap(Map<String, dynamic> map) {
    return ServicesPackageResponse(
      payload: List<ServicesPackageEntity>.from(
          map['payload']?.map((x) => ServicesPackageEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesPackageResponse.fromJson(String source) =>
      ServicesPackageResponse.fromMap(json.decode(source));
}
