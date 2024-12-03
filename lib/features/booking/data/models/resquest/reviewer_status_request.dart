import 'dart:convert';
import 'package:movemate/utils/enums/enums_export.dart';

class Voucher {
  final int id;
  final int promotionCategoryId;

  Voucher({
    required this.id,
    required this.promotionCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'promotionCategoryId': promotionCategoryId,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] ?? 0,
      promotionCategoryId: map['promotionCategoryId'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) =>
      Voucher.fromMap(json.decode(source));
}

class ReviewerStatusRequest {
  final BookingStatusType status;
  final List<Voucher>? vouchers; // Optional field for vouchers

  ReviewerStatusRequest({
    required this.status,
    this.vouchers, // Optional parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.type,
      'vouchers': vouchers
          ?.map((voucher) => voucher.toMap())
          .toList(), // Convert vouchers list to map if not null
    };
  }

  factory ReviewerStatusRequest.fromMap(Map<String, dynamic> map) {
    return ReviewerStatusRequest(
      status: (map['status'] as String).toBookingTypeEnum(),
      vouchers: map['vouchers'] != null
          ? List<Voucher>.from(map['vouchers'].map((x) => Voucher.fromMap(x)))
          : null, // Handle optional vouchers
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewerStatusRequest.fromJson(String source) =>
      ReviewerStatusRequest.fromMap(json.decode(source));
}
