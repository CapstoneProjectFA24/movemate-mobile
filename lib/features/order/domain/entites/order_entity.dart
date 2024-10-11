import 'dart:convert';

class OrderEntity {
  final int id;
  final int userId;
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
  final String estimatedDeliveryTime;
  final bool isDeposited;
  final bool isBonus;
  final bool isReported;
  final String? reportedReason;
  final bool isDeleted;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String? updatedBy;
  final String? review;
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

  OrderEntity({
    required this.id,
    required this.userId,
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
    required this.bonus,
    required this.typeBooking,
    required this.estimatedAcreage,
    required this.roomNumber,
    required this.floorsNumber,
    required this.isManyItems,
    required this.estimatedTotalWeight,
    required this.isCancel,
    required this.cancelReason,
    required this.estimatedWeight,
    required this.estimatedHeight,
    required this.estimatedWidth,
    required this.estimatedLength,
    required this.estimatedVolume,
    required this.isPorter,
    required this.isRoundTrip,
    required this.note,
    required this.totalFee,
    required this.feeInfo,
    required this.bookingTrackers,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
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
      estimatedDeliveryTime: map['estimatedDeliveryTime'] ?? '',
      isDeposited: map['isDeposited'] ?? false,
      isBonus: map['isBonus'] ?? false,
      isReported: map['isReported'] ?? false,
      reportedReason: map['reportedReason'],
      isDeleted: map['isDeleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
      createdBy: map['createdBy'] ?? '',
      updatedAt: DateTime.parse(map['updatedAt'] ?? ''),
      updatedBy: map['updatedBy'],
      review: map['review'],
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
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
    };
  }

  String toJson() => json.encode(toMap());

  factory OrderEntity.fromJson(String source) =>
      OrderEntity.fromMap(json.decode(source));
}
