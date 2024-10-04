import 'dart:convert';

class BookingRequest {
  final int id;
  final int userId;
  final int houseTypeId;
  final double? deposit;
  final String? status;
  final String? pickupAddress;
  final String? pickupPoint;
  final String? deliveryAddress;
  final String? deliveryPoint;
  final String? estimatedDistance;
  final double? total;
  final double? totalReal;
  final String? estimatedDeliveryTime;
  final bool? isDeposited;
  final bool? isBonus;
  final bool? isReported;
  final String? reportedReason;
  final bool? isDeleted;
  final String? review;
  final String? bonus;
  final String? typeBooking;
  final String? roomNumber;
  final String? floorsNumber;
  final bool? isManyItems;
  final bool? isCancel;
  final String? cancelReason;
  final bool? isPorter;
  final bool? isRoundTrip;
  final String? note;
  final double? totalFee;
  final DateTime? bookingAt;
  final bool? isReviewOnline;

  BookingRequest({
    required this.id,
    required this.userId,
    required this.houseTypeId,
    this.deposit,
    this.status,
    this.pickupAddress,
    this.pickupPoint,
    this.deliveryAddress,
    this.deliveryPoint,
    this.estimatedDistance,
    this.total,
    this.totalReal,
    this.estimatedDeliveryTime,
    this.isDeposited,
    this.isBonus,
    this.isReported,
    this.reportedReason,
    this.isDeleted,
    this.review,
    this.bonus,
    this.typeBooking,
    this.roomNumber,
    this.floorsNumber,
    this.isManyItems,
    this.isCancel,
    this.cancelReason,
    this.isPorter,
    this.isRoundTrip,
    this.note,
    this.totalFee,
    this.bookingAt,
    this.isReviewOnline,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'user_id': userId});
    result.addAll({'house_type_id': houseTypeId});
    result.addAll({'deposit': deposit});
    result.addAll({'status': status});
    result.addAll({'pickup_address': pickupAddress});
    result.addAll({'pickup_point': pickupPoint});
    result.addAll({'delivery_address': deliveryAddress});
    result.addAll({'delivery_point': deliveryPoint});
    result.addAll({'estimated_distance': estimatedDistance});
    result.addAll({'total': total});
    result.addAll({'total_real': totalReal});
    result.addAll({'estimated_delivery_time': estimatedDeliveryTime});
    result.addAll({'is_deposited': isDeposited});
    result.addAll({'is_bonus': isBonus});
    result.addAll({'is_reported': isReported});
    result.addAll({'reported_reason': reportedReason});
    result.addAll({'is_deleted': isDeleted});
    result.addAll({'review': review});
    result.addAll({'bonus': bonus});
    result.addAll({'type_booking': typeBooking});
    result.addAll({'room_number': roomNumber});
    result.addAll({'floors_number': floorsNumber});
    result.addAll({'is_many_items': isManyItems});
    result.addAll({'is_cancel': isCancel});
    result.addAll({'cancel_reason': cancelReason});
    result.addAll({'is_porter': isPorter});
    result.addAll({'is_round_trip': isRoundTrip});
    result.addAll({'note': note});
    result.addAll({'total_fee': totalFee});
    result.addAll({'booking_at': bookingAt?.toIso8601String()});
    result.addAll({'is_review_online': isReviewOnline});
    return result;
  }

  factory BookingRequest.fromMap(Map<String, dynamic> map) {
    return BookingRequest(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      houseTypeId: map['house_type_id'] ?? '',
      deposit: map['deposit']?.toDouble() ?? '',
      status: map['status'] ?? '',
      pickupAddress: map['pickup_address'] ?? '',
      pickupPoint: map['pickup_point'] ?? '',
      deliveryAddress: map['delivery_address'] ?? '',
      deliveryPoint: map['delivery_point'] ?? '',
      estimatedDistance: map['estimated_distance'] ?? '',
      total: map['total']?.toDouble() ?? '',
      totalReal: map['total_real']?.toDouble() ?? '',
      estimatedDeliveryTime: map['estimated_delivery_time'] ?? '',
      isDeposited: map['is_deposited'] ?? '',
      isBonus: map['is_bonus'] ?? '',
      isReported: map['is_reported'] ?? '',
      reportedReason: map['reported_reason'] ?? '',
      isDeleted: map['is_deleted'] ?? '',
      review: map['review'] ?? '',
      bonus: map['bonus'] ?? '',
      typeBooking: map['type_booking'] ?? '',
      roomNumber: map['room_number'] ?? '',
      floorsNumber: map['floors_number'] ?? '',
      isManyItems: map['is_many_items'] ?? '',
      isCancel: map['is_cancel'] ?? '',
      cancelReason: map['cancel_reason'] ?? '',
      isPorter: map['is_porter'] ?? '',
      isRoundTrip: map['is_round_trip'] ?? '',
      note: map['note'] ?? '',
      totalFee: map['total_fee']?.toDouble() ?? '',
      bookingAt:
          map['booking_at'] != null ? DateTime.parse(map['booking_at']) : null,
      isReviewOnline: map['is_review_online'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingRequest.fromJson(String source) =>
      BookingRequest.fromMap(json.decode(source));
}
