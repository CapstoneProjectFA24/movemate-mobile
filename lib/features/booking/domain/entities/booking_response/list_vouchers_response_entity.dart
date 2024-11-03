import 'dart:convert';

class ListVouchersResponseEntity {
  final int? id;
  final int? promotionCategoryId;

  ListVouchersResponseEntity({
    this.id,
    this.promotionCategoryId,
  });

  factory ListVouchersResponseEntity.fromMap(Map<String, dynamic> json) {
    return ListVouchersResponseEntity(
      id: json['id'] ?? 0,
      promotionCategoryId: json['promotionCategoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'promotionCategoryId': promotionCategoryId,
    };
  }

  String toJson() => json.encode(toMap());

  factory ListVouchersResponseEntity.fromJson(String source) =>
      ListVouchersResponseEntity.fromMap(json.decode(source));
}
