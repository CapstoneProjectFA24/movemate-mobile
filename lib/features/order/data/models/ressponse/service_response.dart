import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';

class ServiceResponse {
  final List<ServicesPackageEntity> payload;

  ServiceResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ServiceResponse.fromMap(Map<String, dynamic> map) {
    return ServiceResponse(
      payload: List<ServicesPackageEntity>.from(
          map['payload']?.map((x) => ServicesPackageEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceResponse.fromJson(String source) =>
      ServiceResponse.fromMap(json.decode(source));
}
