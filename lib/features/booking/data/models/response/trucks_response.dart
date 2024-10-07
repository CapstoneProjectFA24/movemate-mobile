import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class TruckResponse {
  final List<TruckCategoryEntity> payload;

  TruckResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    print("call in response $result");
    return result;
  }

  factory TruckResponse.fromMap(Map<String, dynamic> map) {
    return TruckResponse(
      payload: List<TruckCategoryEntity>.from(
          map['payload']?.map((x) => TruckCategoryEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckResponse.fromJson(String source) =>
      TruckResponse.fromMap(json.decode(source));
}
