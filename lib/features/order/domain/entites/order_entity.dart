import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_tracker_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/fee_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/list_vouchers_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';

class OrderEntity {
  final int id;
  final int userId;
  final int houseTypeId;
  HouseTypeEntity? houseType;
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
  final DateTime createdAt;
  final String? createdBy;
  final DateTime updatedAt;
  final DateTime reviewAt;
  final DateTime bookingAt;
  final String? updatedBy;
  final String? review;
  final bool isReviewOnline;
  final String? bonus;
  final String typeBooking;
  final String? estimatedAcreage;
  final String roomNumber;
  final String floorsNumber;
  final bool isManyItems;
  final String? estimatedTotalWeight;
  final bool isCancel;
  final String? cancelReason;
  final String? estimatedWeight;
  final String? estimatedHeight;
  final String? estimatedWidth;
  final String? estimatedLength;
  final String? estimatedVolume;
  final bool isPorter;
  final bool isRoundTrip;
  final bool? isUpdated;
  final bool? isInsurance;
  final bool? isUnchanged;
  final String? note;
  final double totalFee;
  final int truckNumber;
  final String? feeInfo;
  final List<AssignmentResponseEntity> assignments;
  final List<BookingTrackerResponseEntity> bookingTrackers;
  final List<BookingDetailResponseEntity> bookingDetails;
  final List<FeeDetailResponseEntity> feeDetails;
  final List<ListVouchersResponseEntity>? vouchers;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.houseTypeId,
    this.houseType,
    required this.deposit,
    required this.status,
    required this.pickupAddress,
    required this.pickupPoint,
    required this.deliveryAddress,
    required this.deliveryPoint,
    required this.isUseBox,
    required this.boxType,
    required this.estimatedDistance,
    required this.total,
    required this.totalReal,
    required this.estimatedDeliveryTime,
    required this.isDeposited,
    required this.isBonus,
    required this.isReported,
    required this.reportedReason,
    required this.isDeleted,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.reviewAt,
    required this.bookingAt,
    required this.updatedBy,
    required this.review,
    required this.isReviewOnline,
    required this.bonus,
    required this.typeBooking,
    required this.estimatedAcreage,
    required this.roomNumber,
    required this.floorsNumber,
    required this.isManyItems,
    this.estimatedTotalWeight,
    required this.isCancel,
    required this.cancelReason,
    this.estimatedWeight,
    this.estimatedHeight,
    this.estimatedWidth,
    this.estimatedLength,
    this.estimatedVolume,
    required this.isPorter,
    required this.isRoundTrip,
    this.isUpdated,
    this.isInsurance,
    this.isUnchanged,
    required this.note,
    required this.totalFee,
    required this.feeInfo,
    required this.truckNumber,
    required this.bookingTrackers,
    required this.assignments,
    required this.feeDetails,
    required this.bookingDetails,
    this.vouchers,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    // Define the format that matches the API response
    final dateFormat = DateFormat('MM/dd/yyyy HH:mm:ss');

    return OrderEntity(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      houseTypeId: map['houseTypeId'] ?? 0,
      deposit: (map['deposit'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      isUseBox: map['isUseBox'] ?? false,
      boxType: map['boxType'],
      estimatedDistance: map['estimatedDistance'] ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      totalReal: (map['totalReal'] as num?)?.toDouble() ?? 0.0,
      estimatedDeliveryTime: map['estimatedDeliveryTime'],
      isDeposited: map['isDeposited'] ?? false,
      isBonus: map['isBonus'] ?? false,
      isReported: map['isReported'] ?? false,
      reportedReason: map['reportedReason'],
      isDeleted: map['isDeleted'] ?? false,
      isUpdated: map['isUpdated'] ?? false,
      isInsurance: map['isInsurance'] ?? false,
      isUnchanged: map['isUnchanged'] ?? false,
      createdAt: map['createdAt'] != null
          ? dateFormat.parse(map['createdAt'])
          : DateTime.now(),
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'] != null
          ? dateFormat.parse(map['updatedAt'])
          : DateTime.now(),
      reviewAt: map['reviewAt'] != null
          ? dateFormat.parse(map['reviewAt'])
          : DateTime.now(),
      bookingAt: map['bookingAt'] != null
          ? dateFormat.parse(map['bookingAt'])
          : DateTime.now(),
      updatedBy: map['updatedBy'],
      review: map['review'],
      isReviewOnline: map['isReviewOnline'],
      bonus: map['bonus'],
      typeBooking: map['typeBooking'] ?? '',
      estimatedAcreage: map['estimatedAcreage'],
      roomNumber: map['roomNumber'] ?? '',
      floorsNumber: map['floorsNumber'] ?? '',
      isManyItems: map['isManyItems'] ?? false,
      estimatedTotalWeight: map['estimatedTotalWeight'],
      isCancel: map['isCancel'] ?? false,
      cancelReason: map['cancelReason'],
      estimatedWeight: map['estimatedWeight'],
      estimatedHeight: map['estimatedHeight'],
      estimatedWidth: map['estimatedWidth'],
      estimatedLength: map['estimatedLength'],
      estimatedVolume: map['estimatedVolume'],
      isPorter: map['isPorter'] ?? false,
      isRoundTrip: map['isRoundTrip'] ?? false,
      note: map['note'],
      totalFee: (map['totalFee'] as num?)?.toDouble() ?? 0.0,
      truckNumber: map['truckNumber'] ?? 0,
      feeInfo: map['feeInfo'],
      assignments: (map['assignments'] as List<dynamic>?)
              ?.map((e) => AssignmentResponseEntity.fromMap(e))
              .toList() ??
          [],
      bookingTrackers: (map['bookingTrackers'] as List<dynamic>?)
              ?.map((e) => BookingTrackerResponseEntity.fromMap(e))
              .toList() ??
          [],
      bookingDetails: (map['bookingDetails'] as List<dynamic>?)
              ?.map((e) => BookingDetailResponseEntity.fromMap(e))
              .toList() ??
          [],
      feeDetails: (map['feeDetails'] as List<dynamic>?)
              ?.map((e) => FeeDetailResponseEntity.fromMap(e))
              .toList() ??
          [],
      vouchers: (map['vouchers'] as List<dynamic>?)
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
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt.toIso8601String(),
      'reviewAt': reviewAt.toIso8601String(),
      'bookingAt': bookingAt.toIso8601String(),
      'updatedBy': updatedBy,
      'review': review,
      'isReviewOnline': isReviewOnline,
      'bonus': bonus,
      'typeBooking': typeBooking,
      'estimatedAcreage': estimatedAcreage,
      'roomNumber': roomNumber,
      'floorsNumber': floorsNumber,
      'isManyItems': isManyItems,
      'estimatedTotalWeight': estimatedTotalWeight,
      'isCancel': isCancel,
      'cancelReason': cancelReason,
      'estimatedWeight': estimatedWeight,
      'estimatedHeight': estimatedHeight,
      'estimatedWidth': estimatedWidth,
      'estimatedLength': estimatedLength,
      'estimatedVolume': estimatedVolume,
      'isPorter': isPorter,
      'isRoundTrip': isRoundTrip,
      'isUpdated': isUpdated,
      'isInsurance': isInsurance,
      'isUnchanged': isUnchanged,
      'note': note,
      'totalFee': totalFee,
      'truckNumber': truckNumber,
      'feeInfo': feeInfo,
      'assignments': assignments.map((e) => e.toMap()).toList(),
      'bookingTrackers': bookingTrackers.map((e) => e.toMap()).toList(),
      'bookingDetails': bookingDetails.map((e) => e.toMap()).toList(),
      'feeDetails': feeDetails.map((e) => e.toMap()).toList(),
      'vouchers': vouchers?.map((e) => e.toMap()).toList(),
    };
  }

  factory OrderEntity.fromBookingResponse(BookingResponseEntity response) {
    print("convert data from bookingresponse to order entity");
    final dateFormat =
        DateFormat('MM/dd/yyyy HH:mm:ss'); // Định dạng đúng với chuỗi từ API

    DateTime parseDate(String? dateString) {
      if (dateString == null || dateString.trim().isEmpty) {
        // Bạn có thể chọn cách xử lý khác như trả về một ngày mặc định
        print('Warning: Date string is null or empty.');
        return DateTime.now();
      }
      try {
        return dateFormat.parseStrict(dateString);
      } catch (e) {
        print('Error parsing date "$dateString": $e');
        // Bạn có thể chọn cách xử lý khác như trả về một ngày mặc định
        return DateTime.now();
      }
    }

    return OrderEntity(
      id: response.id,
      userId: response.userId,
      houseTypeId: response.houseTypeId,
      deposit: response.deposit,
      status: response.status,
      pickupAddress: response.pickupAddress,
      pickupPoint: response.pickupPoint,
      deliveryAddress: response.deliveryAddress,
      deliveryPoint: response.deliveryPoint,
      isUseBox: response.isUseBox,
      boxType: response.boxType,
      estimatedDistance: response.estimatedDistance,
      total: response.total,
      totalReal: response.totalReal,
      estimatedDeliveryTime: response.estimatedDeliveryTime,
      isDeposited: response.isDeposited,
      isBonus: response.isBonus,
      isReported: response.isReported,
      reportedReason: response.reportedReason,
      isDeleted: response.isDeleted,
      createdAt: parseDate(response.createdAt),
      createdBy: response.createdBy,
      updatedAt: parseDate(response.updatedAt),
      reviewAt: parseDate(response.reviewAt),
      bookingAt: parseDate(response.bookingAt),
      updatedBy: response.updatedBy,
      review: response.review,
      isReviewOnline: response.isReviewOnline,
      bonus: response.bonus,
      typeBooking: response.typeBooking,
      estimatedAcreage: response.estimatedAcreage,
      roomNumber: response.roomNumber,
      floorsNumber: response.floorsNumber,
      isManyItems: response.isManyItems,
      isCancel: response.isCancel,
      cancelReason: response.cancelReason,
      isPorter: response.isPorter,
      isRoundTrip: response.isRoundTrip,
      isUpdated: response.isUpdated,
      isInsurance: response.isInsurance,
      isUnchanged: response.isUnchanged,
      note: response.note ?? '',
      totalFee: response.totalFee,
      truckNumber: response.truckNumber,
      feeInfo: response.feeInfo,
      bookingTrackers: response.bookingTrackers,
      assignments: response.assignments,
      feeDetails: response.feeDetails,
      bookingDetails: response.bookingDetails,
      vouchers: response.vouchers,
    );
  }

  factory OrderEntity.fromJson(String source) =>
      OrderEntity.fromMap(json.decode(source));
}
