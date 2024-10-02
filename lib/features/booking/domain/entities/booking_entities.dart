import 'dart:convert';

class BookingEntities {
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

  BookingEntities({
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
    return {
      'id': id,
      'user_id': userId,
      'house_type_id': houseTypeId,
      'deposit': deposit,
      'status': status,
      'pickup_address': pickupAddress,
      'pickup_point': pickupPoint,
      'delivery_address': deliveryAddress,
      'delivery_point': deliveryPoint,
      'estimated_distance': estimatedDistance,
      'total': total,
      'total_real': totalReal,
      'estimated_delivery_time': estimatedDeliveryTime,
      'is_deposited': isDeposited,
      'is_bonus': isBonus,
      'is_reported': isReported,
      'reported_reason': reportedReason,
      'is_deleted': isDeleted,
      'review': review,
      'bonus': bonus,
      'type_booking': typeBooking,
      'room_number': roomNumber,
      'floors_number': floorsNumber,
      'is_many_items': isManyItems,
      'is_cancel': isCancel,
      'cancel_reason': cancelReason,
      'is_porter': isPorter,
      'is_round_trip': isRoundTrip,
      'note': note,
      'total_fee': totalFee,
      'booking_at': bookingAt?.toIso8601String(),
      'is_review_online': isReviewOnline,
    };
  }

  factory BookingEntities.fromMap(Map<String, dynamic> map) {
    return BookingEntities(
      id: map['id'],
      userId: map['user_id'],
      houseTypeId: map['house_type_id'],
      deposit: map['deposit']?.toDouble(),
      status: map['status'],
      pickupAddress: map['pickup_address'],
      pickupPoint: map['pickup_point'],
      deliveryAddress: map['delivery_address'],
      deliveryPoint: map['delivery_point'],
      estimatedDistance: map['estimated_distance'],
      total: map['total']?.toDouble(),
      totalReal: map['total_real']?.toDouble(),
      estimatedDeliveryTime: map['estimated_delivery_time'],
      isDeposited: map['is_deposited'],
      isBonus: map['is_bonus'],
      isReported: map['is_reported'],
      reportedReason: map['reported_reason'],
      isDeleted: map['is_deleted'],
      review: map['review'],
      bonus: map['bonus'],
      typeBooking: map['type_booking'],
      roomNumber: map['room_number'],
      floorsNumber: map['floors_number'],
      isManyItems: map['is_many_items'],
      isCancel: map['is_cancel'],
      cancelReason: map['cancel_reason'],
      isPorter: map['is_porter'],
      isRoundTrip: map['is_round_trip'],
      note: map['note'],
      totalFee: map['total_fee']?.toDouble(),
      bookingAt:
          map['booking_at'] != null ? DateTime.parse(map['booking_at']) : null,
      isReviewOnline: map['is_review_online'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingEntities.fromJson(String source) =>
      BookingEntities.fromMap(json.decode(source));
}
