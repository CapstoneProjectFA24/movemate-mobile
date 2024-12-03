import 'dart:convert';

import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';

class PromotionObjectResponse {
  final PromotionAboutUserEntity payload;

  PromotionObjectResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory PromotionObjectResponse.fromMap(Map<String, dynamic> map) {
    return PromotionObjectResponse(
      payload: PromotionAboutUserEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionObjectResponse.fromJson(String source) =>
      PromotionObjectResponse.fromMap(json.decode(source));
}
