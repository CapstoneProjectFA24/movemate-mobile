import 'dart:convert';

import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';

class PromotionByIdResponse {
  final PromotionEntity payload;

  PromotionByIdResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory PromotionByIdResponse.fromMap(Map<String, dynamic> map) {
    return PromotionByIdResponse(
      payload: PromotionEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionByIdResponse.fromJson(String source) =>
      PromotionByIdResponse.fromMap(json.decode(source));
}
