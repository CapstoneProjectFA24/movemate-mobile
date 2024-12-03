import 'dart:convert';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';

class PromotionAboutUserEntity {
  final List<PromotionEntity> promotionUser;
  final List<PromotionEntity> promotionNoUser;

  PromotionAboutUserEntity({
    required this.promotionUser,
    required this.promotionNoUser,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll(
        {'promotionUser': promotionUser.map((x) => x.toMap()).toList()});
    result.addAll(
        {'promotionNoUser': promotionNoUser.map((x) => x.toMap()).toList()});
    return result;
  }

  factory PromotionAboutUserEntity.fromMap(Map<String, dynamic> map) {
    return PromotionAboutUserEntity(
      promotionUser: List<PromotionEntity>.from(
          map['promotionUser']?.map((x) => PromotionEntity.fromMap(x)) ?? []),
      promotionNoUser: List<PromotionEntity>.from(
          map['promotionNoUser']?.map((x) => PromotionEntity.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionAboutUserEntity.fromJson(String source) =>
      PromotionAboutUserEntity.fromMap(json.decode(source));
}
