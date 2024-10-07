import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class ServicesResponse {
  final ServiceEntity payload;
  final List<TruckCategoryEntity> trucks;

  ServicesResponse({
    required this.payload,
    required this.trucks,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});
    result.addAll({'payload': trucks.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ServicesResponse.fromMap(Map<String, dynamic> map) {
    return ServicesResponse(
      payload: ServiceEntity.fromMap(map["payload"]),
      trucks: List<TruckCategoryEntity>.from(
          map['payload']?.map((x) => TruckCategoryEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesResponse.fromJson(String source) =>
      ServicesResponse.fromMap(json.decode(source));
}
