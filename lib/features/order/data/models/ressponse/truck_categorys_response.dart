import 'dart:convert';

import 'package:movemate/features/order/domain/entites/truck_categories_entity.dart';


class TruckCategorysResponse {
  final List<TruckCategoriesEntity> payload;

  TruckCategorysResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory TruckCategorysResponse.fromMap(Map<String, dynamic> map) {
    return TruckCategorysResponse(
      payload: List<TruckCategoriesEntity>.from(
          map['payload']?.map((x) => TruckCategoriesEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckCategorysResponse.fromJson(String source) =>
      TruckCategorysResponse.fromMap(json.decode(source));
}
