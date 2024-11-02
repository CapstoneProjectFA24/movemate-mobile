import 'dart:convert';

import 'package:movemate/features/order/domain/entites/truck_categories_entity.dart';


class TruckCategoryObjResponse {
  final TruckCategoriesEntity payload;

  TruckCategoryObjResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory TruckCategoryObjResponse.fromMap(Map<String, dynamic> map) {
    return TruckCategoryObjResponse(
      payload: TruckCategoriesEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckCategoryObjResponse.fromJson(String source) =>
      TruckCategoryObjResponse.fromMap(json.decode(source));
}
