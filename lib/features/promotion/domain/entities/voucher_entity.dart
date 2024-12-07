import 'dart:convert';

class VoucherEntity {
  final int id;
  final int userId;
  final int promotionCategoryId;
  final int bookingId;
  final double price;
  final String code;
  final bool isActived;

  VoucherEntity({
    required this.id,
    required this.userId,
    required this.promotionCategoryId,
    required this.bookingId,
    required this.price,
    required this.code,
    required this.isActived,
  });

  factory VoucherEntity.fromMap(Map<String, dynamic> map) {
    return VoucherEntity(
      id: map['id'] ?? 0, // Đảm bảo `id` luôn là số nguyên không null
      userId: map['userId'] ?? 0, // Cung cấp giá trị mặc định nếu null
      promotionCategoryId:
          map['promotionCategoryId'] ?? 0, // Cung cấp giá trị mặc định nếu null
      bookingId: map['bookingId'] ?? 0, // Cung cấp giá trị mặc định nếu null
      price: (map['price'] != null)
          ? (map['price'] is int
              ? (map['price'] as int).toDouble()
              : map['price']?.toDouble())
          : 0.0, // Chuyển đổi giá trị sang double nếu không null
      code: map['code'] ?? '', // Cung cấp chuỗi rỗng nếu null
      isActived: map['isActived'] ?? false, // Mặc định là `false` nếu null
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
