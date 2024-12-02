import 'dart:convert';

import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';


class PromotionResponse {
  final List<PromotionEntity> payload;

  PromotionResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory PromotionResponse.fromMap(Map<String, dynamic> map) {
    return PromotionResponse(
      payload: List<PromotionEntity>.from(
          map['payload']?.map((x) => PromotionEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionResponse.fromJson(String source) =>
      PromotionResponse.fromMap(json.decode(source));
}
