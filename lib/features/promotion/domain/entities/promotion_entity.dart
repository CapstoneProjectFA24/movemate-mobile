import 'dart:convert';
import 'package:intl/intl.dart';
// import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';

class PromotionEntity {
  final int id;
  final bool isPublic;
  final DateTime startDate;
  final DateTime endDate;
  final int discountRate;
  final int discountMax;
  final int requireMin;
  final int discountMin;
  final String name;
  final String description;
  final String type;
  final int quantity;
  final DateTime startBookingTime;
  final DateTime endBookingTime;
  final bool isInfinite;
  final int serviceId;
  // final List<VoucherEntity> vouchers;

  PromotionEntity({
    required this.id,
    required this.isPublic,
    required this.startDate,
    required this.endDate,
    required this.discountRate,
    required this.discountMax,
    required this.requireMin,
    required this.discountMin,
    required this.name,
    required this.description,
    required this.type,
    required this.quantity,
    required this.startBookingTime,
    required this.endBookingTime,
    required this.isInfinite,
    required this.serviceId,
    // required this.vouchers,
  });

  factory PromotionEntity.fromMap(Map<String, dynamic> map) {
    final dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    return PromotionEntity(
      id: map['id'] ?? 0,
      isPublic: map['isPublic'] ?? false,
      startDate: dateFormat.parse(map['startDate']),
      endDate: dateFormat.parse(map['endDate']),
      discountRate: map['discountRate'] ?? 0,
      discountMax: map['discountMax'] ?? 0,
      requireMin: map['requireMin'] ?? 0,
      discountMin: map['discountMin'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      quantity: map['quantity'] ?? 0,
      startBookingTime: dateFormat.parse(map['startBookingTime']),
      endBookingTime: dateFormat.parse(map['endBookingTime']),
      isInfinite: map['isInfinite'] ?? false,
      serviceId: map['serviceId'] ?? 0,
      // vouchers: map['vouchers'] ?? [],
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
      'name': name,
      'description': description,
      'type': type,
      'quantity': quantity,
      'startBookingTime': startBookingTime.toIso8601String(),
      'endBookingTime': endBookingTime.toIso8601String(),
      'isInfinite': isInfinite,
      'serviceId': serviceId,
      // 'vouchers': vouchers,
    };
  }

  factory PromotionEntity.fromJson(String source) =>
      PromotionEntity.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
