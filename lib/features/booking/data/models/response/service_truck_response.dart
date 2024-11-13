// service_truck_response.dart

import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';

class ServiceTruckResponse {
  final List<InverseParentServiceEntity> payload;

  ServiceTruckResponse({
    required this.payload,
  });

  factory ServiceTruckResponse.fromMap(Map<String, dynamic> map) {
    return ServiceTruckResponse(
      payload: map['payload'] != null
          ? List<InverseParentServiceEntity>.from(
              map['payload'].map((x) => InverseParentServiceEntity.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payload': payload.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ServiceTruckResponse.fromJson(String source) =>
      ServiceTruckResponse.fromMap(json.decode(source));
}
