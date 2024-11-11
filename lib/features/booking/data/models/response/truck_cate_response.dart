import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class TruckCateResponse {
  final TruckCategoryEntity payload;

  TruckCateResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory TruckCateResponse.fromMap(Map<String, dynamic> map) {
    return TruckCateResponse(
      payload: TruckCategoryEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckCateResponse.fromJson(String source) =>
      TruckCateResponse.fromMap(json.decode(source));
}
