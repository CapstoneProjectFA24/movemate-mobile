import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/service_entity.dart';

class ServicesResponse {
  final ServiceEntity payload;

  ServicesResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory ServicesResponse.fromMap(Map<String, dynamic> map) {
    return ServicesResponse(
      payload: ServiceEntity.fromMap(map["payload"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesResponse.fromJson(String source) =>
      ServicesResponse.fromMap(json.decode(source));
}
