import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class TruckCatePriceResponse {
  final List<TruckCategoryEntity> payload;

  TruckCatePriceResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory TruckCatePriceResponse.fromMap(Map<String, dynamic> map) {
    return TruckCatePriceResponse(
      payload: List<TruckCategoryEntity>.from(
          map['payload']?.map((x) => TruckCategoryEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckCatePriceResponse.fromJson(String source) =>
      TruckCatePriceResponse.fromMap(json.decode(source));
}
