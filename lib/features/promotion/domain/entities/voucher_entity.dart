import 'dart:convert';

class VoucherEntity {
  final int id;
  final int? userId;
  final int promotionCategoryId;
  final int? bookingId;
  final double price;
  final String code;
  final bool isActived;

  VoucherEntity({
    required this.id,
    this.userId,
    required this.promotionCategoryId,
    this.bookingId,
    required this.price,
    required this.code,
    required this.isActived,
  });

  factory VoucherEntity.fromMap(Map<String, dynamic> map) {
    return VoucherEntity(
      id: map['id'] ?? 0, // Ensure `id` is always a non-null integer
      userId: map['userId'], // Nullable, no default needed
      promotionCategoryId:
          map['promotionCategoryId'] ?? 0, // Default to 0 if missing
      bookingId: map['bookingId'], // Nullable, no default needed
      price: (map['price'] != null)
          ? map['price']?.toDouble()
          : 0.0, // Convert price to double if not null
      code: map['code'] ??
          '', // Ensure `code` is a non-null string (empty string as fallback)
      isActived: map['isActived'] ?? false, // Default to `false` if missing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'promotionCategoryId': promotionCategoryId,
      'bookingId': bookingId,
      'price': price,
      'code': code,
      'isActived': isActived,
    };
  }

  String toJson() => json.encode(toMap());

  factory VoucherEntity.fromJson(String source) =>
      VoucherEntity.fromMap(json.decode(source));
}
