// lib/features/booking/domain/entities/fee_detail_response_entity.dart

import 'dart:convert';

class FeeDetailResponseEntity {
  final int id;
  final int bookingId;
  final int feeSettingId;
  final String name;
  final String description;
  final int amount;
  final int? quantity;

  FeeDetailResponseEntity({
    required this.id,
    required this.bookingId,
    required this.feeSettingId,
    required this.name,
    required this.description,
    required this.amount,
    this.quantity,
  });

  factory FeeDetailResponseEntity.fromMap(Map<String, dynamic> json) {
    return FeeDetailResponseEntity(
      id: json['id'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      feeSettingId: json['feeSettingId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'feeSettingId': feeSettingId,
      'name': name,
      'description': description,
      'amount': amount,
      'quantity': quantity,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'FeeDetailResponseEntity('
        'id: $id, '
        'bookingId: $bookingId, '
        'feeSettingId: $feeSettingId, '
        'name: $name, '
        'description: $description, '
        'amount: $amount, '
        'quantity: $quantity'
        ')';
  }

  factory FeeDetailResponseEntity.fromJson(String source) =>
      FeeDetailResponseEntity.fromMap(json.decode(source));
}
