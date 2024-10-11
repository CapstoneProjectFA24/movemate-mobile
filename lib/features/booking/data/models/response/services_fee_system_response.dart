import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';

class ServicesFeeSystemResponse {
  final List<ServicesFeeSystemEntity> payload;

  ServicesFeeSystemResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ServicesFeeSystemResponse.fromMap(Map<String, dynamic> map) {
  return ServicesFeeSystemResponse(
    payload: List<ServicesFeeSystemEntity>.from(
        map['payload']?.map((x) => ServicesFeeSystemEntity.fromMap(x))),
  );
}


  String toJson() => json.encode(toMap());

  factory ServicesFeeSystemResponse.fromJson(String source) =>
      ServicesFeeSystemResponse.fromMap(json.decode(source));
}
