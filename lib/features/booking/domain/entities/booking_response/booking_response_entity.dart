import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_response/booking_details_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_trackers_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/fee_details_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/service_details_response_entity.dart';

class BookingResponseEntity {
  final int id;
  final int userId;
  final int houseTypeId;
  final int deposit;
  final String status;
  final String pickupAddress;
  final String pickupPoint;
  final String deliveryAddress;
  final String deliveryPoint;
  final bool isUseBox;
  final String? boxType;
  final String estimatedDistance;
  final int total;
  final int totalReal;
  final String? estimatedDeliveryTime;
  final bool isDeposited;
  final bool isBonus;
  final bool isReported;
  final String? reportedReason;
  final bool isDeleted;
  final String createdAt;
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
  final String note;
  final int totalFee;
  final String? feeInfo;
  final bool isReviewOnline;
  final List<BookingDetailsResponseEntity> bookingDetails;
  final List<BookingTrackersResponseEntity> bookingTrackers;
  final List<ServiceDetailsResponseEntity> serviceDetails;
  final List<FeeDetailsResponseEntity> feeDetails;

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
    required this.note,
    required this.totalFee,
    this.feeInfo,
    required this.isReviewOnline,
    required this.bookingDetails,
    required this.bookingTrackers,
    required this.serviceDetails,
    required this.feeDetails,
  });

  factory BookingResponseEntity.fromMap(Map<String, dynamic> json) {
    return BookingResponseEntity(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      houseTypeId: json['houseTypeId'] ?? 0,
      deposit: json['deposit'] ?? 0,
      status: json['status'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      pickupPoint: json['pickupPoint'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryPoint: json['deliveryPoint'] ?? '',
      isUseBox: json['isUseBox'] ?? false,
      boxType: json['boxType'],
      estimatedDistance: json['estimatedDistance'] ?? '',
      total: json['total'] ?? 0,
      totalReal: json['totalReal'] ?? 0,
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
      isDeposited: json['isDeposited'] ?? false,
      isBonus: json['isBonus'] ?? false,
      isReported: json['isReported'] ?? false,
      reportedReason: json['reportedReason'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
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
      note: json['note'] ?? '',
      totalFee: json['totalFee'] ?? 0,
      feeInfo: json['feeInfo'],
      isReviewOnline: json['isReviewOnline'] ?? false,
      bookingDetails: (json['bookingDetails'] as List<dynamic>?)
              ?.map((e) => BookingDetailsResponseEntity.fromMap(e))
              .toList() ??
          [],
      bookingTrackers: (json['bookingTrackers'] as List<dynamic>?)
              ?.map((e) => BookingTrackersResponseEntity.fromMap(e))
              .toList() ??
          [],
      serviceDetails: (json['serviceDetails'] as List<dynamic>?)
              ?.map((e) => ServiceDetailsResponseEntity.fromMap(e))
              .toList() ??
          [],
      feeDetails: (json['feeDetails'] as List<dynamic>?)
              ?.map((e) => FeeDetailsResponseEntity.fromMap(e))
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
      'note': note,
      'totalFee': totalFee,
      'feeInfo': feeInfo,
      'isReviewOnline': isReviewOnline,
      'bookingDetails': bookingDetails.map((e) => e.toMap()).toList(),
      'bookingTrackers': bookingTrackers.map((e) => e.toMap()).toList(),
      'serviceDetails': serviceDetails.map((e) => e.toMap()).toList(),
      'feeDetails': feeDetails.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory BookingResponseEntity.fromJson(String source) =>
      BookingResponseEntity.fromMap(json.decode(source));
}
