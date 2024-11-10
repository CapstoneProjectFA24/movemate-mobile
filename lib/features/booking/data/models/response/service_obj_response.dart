import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';

class ServiceObjResponse {
  final ServicesPackageEntity payload;

  ServiceObjResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory ServiceObjResponse.fromMap(Map<String, dynamic> map) {
    return ServiceObjResponse(
      payload: ServicesPackageEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceObjResponse.fromJson(String source) =>
      ServiceObjResponse.fromMap(json.decode(source));
}
