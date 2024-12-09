import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
// import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';

class PromotionEntity {
  final int id;
  final bool isPublic;
  final DateTime startDate;
  final DateTime endDate;
  final double discountRate;
  final double discountMax;
  final double requireMin;
  final double discountMin;
  final double? amount;
  final String name;
  final String description;
  final String type;
  final int quantity;
  final DateTime startBookingTime;
  final DateTime endBookingTime;
  final bool isInfinite;
  final int serviceId;
  final List<VoucherEntity> vouchers;

  PromotionEntity({
    required this.id,
    required this.isPublic,
    required this.startDate,
    required this.endDate,
    required this.discountRate,
    required this.discountMax,
    required this.requireMin,
    required this.discountMin,
    required this.amount,
    required this.name,
    required this.description,
    required this.type,
    required this.quantity,
    required this.startBookingTime,
    required this.endBookingTime,
    required this.isInfinite,
    required this.serviceId,
    required this.vouchers,
  });
  factory PromotionEntity.fromMap(Map<String, dynamic> map) {
    final dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return PromotionEntity(
      id: map['id'] ?? 0,
      isPublic: map['isPublic'] ?? false,

      // Convert int to double if necessary

      discountRate:
          (map['discountRate'] != null) ? map['discountRate']?.toDouble() : 0.0,
      discountMax:
          (map['discountMax'] != null) ? map['discountMax']?.toDouble() : 0.0,
      requireMin:
          (map['requireMin'] != null) ? map['requireMin']?.toDouble() : 0.0,
      discountMin:
          (map['discountMin'] != null) ? map['discountMin']?.toDouble() : 0.0,
      amount: (map['amount'] != null) ? map['amount']?.toDouble() : 0.0,

      quantity: map['quantity'] ?? 0,

      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      startDate: map['startDate'] != null
          ? dateFormat.parse(map['startDate'])
          : DateTime.now(), // Hoặc 1 giá trị mặc định nào đó

      endDate: map['endDate'] != null
          ? dateFormat.parse(map['endDate'])
          : DateTime.now(),

      startBookingTime: map['startBookingTime'] != null
          ? dateFormat.parse(map['startBookingTime'])
          : DateTime.now(),

      endBookingTime: map['endBookingTime'] != null
          ? dateFormat.parse(map['endBookingTime'])
          : DateTime.now(),

      isInfinite: map['isInfinite'] ?? false,
      serviceId: map['serviceId'] ?? 0,
      vouchers: List<VoucherEntity>.from(
          map['vouchers']?.map((x) => VoucherEntity.fromMap(x)) ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isPublic': isPublic,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'discountRate': discountRate,
      'discountMax': discountMax,
      'requireMin': requireMin,
      'discountMin': discountMin,
      'amount': amount,
      'name': name,
      'description': description,
      'type': type,
      'quantity': quantity,
      'startBookingTime': startBookingTime.toIso8601String(),
      'endBookingTime': endBookingTime.toIso8601String(),
      'isInfinite': isInfinite,
      'serviceId': serviceId,
      // 'vouchers': vouchers,
      'vouchers': vouchers.map((x) => x.toMap()).toList(),
    };
  }

  factory PromotionEntity.fromJson(String source) =>
      PromotionEntity.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
