import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/vinh/service_entity.dart';


class ServicesResponse {
  final List<ServiceEntity> payload;

  ServicesResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }


  factory ServicesResponse.fromMap(Map<String, dynamic> map) {
  return ServicesResponse(
    payload: List<ServiceEntity>.from(
        map['payload']?.map((x) => ServiceEntity.fromMap(x))),
  );
}


  String toJson() => json.encode(toMap());

  factory ServicesResponse.fromJson(String source) =>
      ServicesResponse.fromMap(json.decode(source));
}
