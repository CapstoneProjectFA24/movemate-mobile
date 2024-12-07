import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';

import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';

import 'package:movemate/features/booking/domain/entities/booking_response/booking_tracker_response_entity.dart';

import 'package:movemate/features/booking/domain/entities/booking_response/fee_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/list_vouchers_response_entity.dart';

class BookingResponseEntity {
  final int id;
  final int userId;
  final int houseTypeId;
  final double deposit;
  final String status;
  final String pickupAddress;
  final String pickupPoint;
  final String deliveryAddress;
  final String deliveryPoint;
  final bool isUseBox;
  final String? boxType;
  final String estimatedDistance;
  final double total;
  final double totalReal;
  final String? estimatedDeliveryTime;
  final bool isDeposited;
  final bool isBonus;
  final bool isReported;
  final String? reportedReason;
  final bool isDeleted;
  final String createdAt;
  final String? bookingAt;
  final String? createdBy;
  final String updatedAt;
  final String? updatedBy;
  final String? review;
  final String? bonus;
  final String typeBooking;
  final String? estimatedAcreage;
  final String roomNumber;
  final String floorsNumber;
  final bool isManyItems;
  final bool isCancel;
  final String? cancelReason;
  final bool isPorter;
  final bool isRoundTrip;
  final bool? isUpdated;
  final bool? isInsurance;
  final bool? isUnchanged;
  final String note;
  final double totalFee;
  final int truckNumber;
  final String? feeInfo;
  final bool isReviewOnline;
  final String? reviewAt;
  final List<AssignmentResponseEntity> assignments;
  final List<BookingTrackerResponseEntity> bookingTrackers;
  final List<BookingDetailResponseEntity> bookingDetails;
  final List<FeeDetailResponseEntity> feeDetails;
  final List<ListVouchersResponseEntity>? vouchers;

  BookingResponseEntity({
    required this.id,
    required this.userId,
    required this.houseTypeId,
    required this.deposit,
    required this.status,
    required this.pickupAddress,
    required this.pickupPoint,
    required this.deliveryAddress,
    required this.deliveryPoint,
    required this.isUseBox,
    this.boxType,
    required this.estimatedDistance,
    required this.total,
    required this.totalReal,
    this.estimatedDeliveryTime,
    required this.isDeposited,
    required this.isBonus,
    required this.isReported,
    this.reportedReason,
    required this.isDeleted,
    required this.createdAt,
    this.bookingAt,
    this.createdBy,
    required this.updatedAt,
    this.updatedBy,
    this.review,
    this.bonus,
    required this.typeBooking,
    this.estimatedAcreage,
    required this.roomNumber,
    required this.floorsNumber,
    required this.isManyItems,
    required this.isCancel,
    this.cancelReason,
    required this.isPorter,
    required this.isRoundTrip,
    this.isUpdated,
    this.isInsurance,
    this.isUnchanged,
    required this.note,
    required this.totalFee,
    this.feeInfo,
    required this.truckNumber,
    required this.isReviewOnline,
    this.reviewAt,
    required this.assignments,
    required this.bookingTrackers,
    required this.bookingDetails,
    required this.feeDetails,
    this.vouchers,
  });

  factory BookingResponseEntity.fromMap(Map<String, dynamic> json) {
    return BookingResponseEntity(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      houseTypeId: json['houseTypeId'] ?? 0,
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      pickupPoint: json['pickupPoint'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryPoint: json['deliveryPoint'] ?? '',
      isUseBox: json['isUseBox'] ?? false,
      boxType: json['boxType'],
      estimatedDistance: json['estimatedDistance'] ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      totalReal: (json['totalReal'] as num?)?.toDouble() ?? 0.0,
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
      isDeposited: json['isDeposited'] ?? false,
      isBonus: json['isBonus'] ?? false,
      isReported: json['isReported'] ?? false,
      reportedReason: json['reportedReason'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      bookingAt: json['bookingAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'] ?? '',
      updatedBy: json['updatedBy'],
      review: json['review'],
      bonus: json['bonus'],
      typeBooking: json['typeBooking'] ?? '',
      estimatedAcreage: json['estimatedAcreage'],
      roomNumber: json['roomNumber'] ?? '',
      floorsNumber: json['floorsNumber'] ?? '',
      isManyItems: json['isManyItems'] ?? false,
      isCancel: json['isCancel'] ?? false,
      cancelReason: json['cancelReason'],
      isPorter: json['isPorter'] ?? false,
      isRoundTrip: json['isRoundTrip'] ?? false,
      isUpdated: json['isUpdated'] ?? false,
      isInsurance: json['isInsurance'] ?? false,
      isUnchanged: json['isUnchanged'] ?? false,
      note: json['note'] ?? '',
      totalFee: (json['totalFee'] as num?)?.toDouble() ?? 0.0,
      truckNumber: json['truckNumber'] ?? 0,
      feeInfo: json['feeInfo'],
      isReviewOnline: json['isReviewOnline'] ?? false,
      reviewAt: json['reviewAt'],
      assignments: (json['assignments'] as List<dynamic>?)
              ?.map((e) => AssignmentResponseEntity.fromMap(e))
              .toList() ??
          [],
      bookingTrackers: (json['bookingTrackers'] as List<dynamic>?)
              ?.map((e) => BookingTrackerResponseEntity.fromMap(e))
              .toList() ??
          [],
      bookingDetails: (json['bookingDetails'] as List<dynamic>?)
              ?.map((e) => BookingDetailResponseEntity.fromMap(e))
              .toList() ??
          [],
      feeDetails: (json['feeDetails'] as List<dynamic>?)
              ?.map((e) => FeeDetailResponseEntity.fromMap(e))
              .toList() ??
          [],
      vouchers: (json['vouchers'] as List<dynamic>?)
              ?.map((e) => ListVouchersResponseEntity.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'houseTypeId': houseTypeId,
      'deposit': deposit,
      'status': status,
      'pickupAddress': pickupAddress,
      'pickupPoint': pickupPoint,
      'deliveryAddress': deliveryAddress,
      'deliveryPoint': deliveryPoint,
      'isUseBox': isUseBox,
      'boxType': boxType,
      'estimatedDistance': estimatedDistance,
      'total': total,
      'totalReal': totalReal,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'isDeposited': isDeposited,
      'isBonus': isBonus,
      'isReported': isReported,
      'reportedReason': reportedReason,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'bookingAt': bookingAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'review': review,
      'bonus': bonus,
      'typeBooking': typeBooking,
      'estimatedAcreage': estimatedAcreage,
      'roomNumber': roomNumber,
      'floorsNumber': floorsNumber,
      'isManyItems': isManyItems,
      'isCancel': isCancel,
      'cancelReason': cancelReason,
      'isPorter': isPorter,
      'isRoundTrip': isRoundTrip,
      'isUpdated': isUpdated,
      'isInsurance': isInsurance,
      'isUnchanged': isUnchanged,
      'note': note,
      'totalFee': totalFee,
      'truckNumber': truckNumber,
      'feeInfo': feeInfo,
      'isReviewOnline': isReviewOnline,
      'reviewAt': reviewAt,
      'assignments': assignments.map((e) => e.toMap()).toList(),
      'bookingTrackers': bookingTrackers.map((e) => e.toMap()).toList(),
      'bookingDetails': bookingDetails.map((e) => e.toMap()).toList(),
      'feeDetails': feeDetails.map((e) => e.toMap()).toList(),
      'vouchers': vouchers?.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'BookingResponseEntity('
        'id: $id, '
        'userId: $userId, '
        'houseTypeId: $houseTypeId, '
        'deposit: $deposit, '
        'status: $status, '
        'pickupAddress: $pickupAddress, '
        'pickupPoint: $pickupPoint, '
        'deliveryAddress: $deliveryAddress, '
        'deliveryPoint: $deliveryPoint, '
        'isUseBox: $isUseBox, '
        'boxType: $boxType, '
        'estimatedDistance: $estimatedDistance, '
        'total: $total, '
        'totalReal: $totalReal, '
        'estimatedDeliveryTime: $estimatedDeliveryTime, '
        'isDeposited: $isDeposited, '
        'isBonus: $isBonus, '
        'isReported: $isReported, '
        'reportedReason: $reportedReason, '
        'isDeleted: $isDeleted, '
        'createdAt: $createdAt, '
        'bookingAt: $bookingAt, '
        'createdBy: $createdBy, '
        'updatedAt: $updatedAt, '
        'updatedBy: $updatedBy, '
        'review: $review, '
        'bonus: $bonus, '
        'typeBooking: $typeBooking, '
        'estimatedAcreage: $estimatedAcreage, '
        'roomNumber: $roomNumber, '
        'floorsNumber: $floorsNumber, '
        'isManyItems: $isManyItems, '
        'isCancel: $isCancel, '
        'cancelReason: $cancelReason, '
        'isPorter: $isPorter, '
        'isRoundTrip: $isRoundTrip, '
        'isUpdated: $isUpdated, '
        'isInsurance: $isInsurance, '
        'isUnchanged: $isUnchanged, '
        'note: $note, '
        'totalFee: $totalFee, '
        'truckNumber: $truckNumber, '
        'feeInfo: $feeInfo, '
        'isReviewOnline: $isReviewOnline, '
        'reviewAt: $reviewAt, '
        'assignments: $assignments, '
        'bookingTrackers: $bookingTrackers, '
        'bookingDetails: $bookingDetails, '
        'feeDetails: $feeDetails, '
        'vouchers: $vouchers'
        ')';
  }

  factory BookingResponseEntity.fromJson(String source) =>
      BookingResponseEntity.fromMap(json.decode(source));
}
