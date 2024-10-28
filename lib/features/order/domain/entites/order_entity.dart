import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';

class OrderEntity {
  final int id;
  final int userId;
  final int houseTypeId;
  HouseTypeEntity? houseType;
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
  final DateTime createdAt;
  final String? createdBy;
  final DateTime updatedAt;
  final String? updatedBy;
  final String? review;
  final bool? isReviewOnline;
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
  final String? note;
  final int totalFee;
  final String? feeInfo;
  final List<dynamic> bookingTrackers;
  final List<dynamic> assignments;
  final List<dynamic> feeDetails;
  final List<dynamic> bookingDetails;

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
    required this.note,
    required this.totalFee,
    required this.feeInfo,
    required this.bookingTrackers,
    required this.assignments,
    required this.feeDetails,
    required this.bookingDetails,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    // Define the format that matches the API response
    final dateFormat = DateFormat('MM/dd/yyyy HH:mm:ss');

    return OrderEntity(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      houseTypeId: map['houseTypeId'] ?? 0,
      deposit: map['deposit'] ?? 0,
      status: map['status'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      isUseBox: map['isUseBox'] ?? false,
      boxType: map['boxType'],
      estimatedDistance: map['estimatedDistance'] ?? '',
      total: map['total'] ?? 0,
      totalReal: map['totalReal'] ?? 0,
      estimatedDeliveryTime: map['estimatedDeliveryTime'],
      isDeposited: map['isDeposited'] ?? false,
      isBonus: map['isBonus'] ?? false,
      isReported: map['isReported'] ?? false,
      reportedReason: map['reportedReason'],
      isDeleted: map['isDeleted'] ?? false,
      createdAt: map['createdAt'] != null
          ? dateFormat.parse(map['createdAt'])
          : DateTime.now(),
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'] != null
          ? dateFormat.parse(map['updatedAt'])
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
      totalFee: map['totalFee'] ?? 0,
      feeInfo: map['feeInfo'],
      bookingTrackers: List<dynamic>.from(map['bookingTrackers'] ?? []),
      assignments: List<dynamic>.from(map['assignments'] ?? []),
      feeDetails: List<dynamic>.from(map['feeDetails'] ?? []),
      bookingDetails: List<dynamic>.from(map['bookingDetails'] ?? []),
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
      'note': note,
      'totalFee': totalFee,
      'feeInfo': feeInfo,
      'bookingTrackers': bookingTrackers,
      'assignments': assignments,
      'feeDetails': feeDetails,
      'bookingDetails': bookingDetails,
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
      note: response.note ?? '',
      totalFee: response.totalFee,
      feeInfo: response.feeInfo,
      bookingTrackers: response.bookingTrackers,
      assignments: response.assignments,
      feeDetails: response.feeDetails,
      bookingDetails: response.bookingDetails,
    );
  }

  factory OrderEntity.fromJson(String source) =>
      OrderEntity.fromMap(json.decode(source));
}
