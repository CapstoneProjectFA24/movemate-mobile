import 'dart:convert';

class ListVouchersResponseEntity {
  final int? id;
  final int? userId;
  final int? promotionCategoryId;
  final int? bookingId;
  final String? code;
  final double? price;
  final bool? isActived;
  //  "id": 147,
  //   "userId": 3,
  //   "promotionCategoryId": 24,
  //   "bookingId": 1,
  //   "price": 3455,
  //   "code": null,
  //   "isActived": true

  ListVouchersResponseEntity({
    this.id,
    this.userId,
    this.promotionCategoryId,
    this.bookingId,
    this.code,
    this.price,
    this.isActived,
  });

  factory ListVouchersResponseEntity.fromMap(Map<String, dynamic> json) {
    return ListVouchersResponseEntity(
      id: json['id'] ?? 0,
      promotionCategoryId: json['promotionCategoryId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      isActived: json['isActived'] as bool,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      code: json['code'] ?? '',
      userId: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'code': code,
      'id': id,
      'isActived': isActived,
      'price': price,
      'promotionCategoryId': promotionCategoryId,
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  factory ListVouchersResponseEntity.fromJson(String source) =>
      ListVouchersResponseEntity.fromMap(json.decode(source));
}
