import 'dart:convert';

class BookingEntities {
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
  final String createdAt;
  final String createdBy;
  final String? updatedAt;
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

  BookingEntities({
    required this.id,
    required this.userId,
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
    required this.estimatedDeliveryTime,
    required this.isDeposited,
    required this.isBonus,
    required this.isReported,
    this.reportedReason,
    required this.isDeleted,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
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
    this.estimatedWeight,
    this.estimatedHeight,
    this.estimatedWidth,
    this.estimatedLength,
    this.estimatedVolume,
    required this.isPorter,
    required this.isRoundTrip,
    this.note,
    required this.totalFee,
    this.feeInfo,
    required this.bookingTrackers,
  });

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

  factory BookingEntities.fromMap(Map<String, dynamic> map) {
    return BookingEntities(
      id: map['id'],
      userId: map['userId'],
      deposit: map['deposit'],
      status: map['status'],
      pickupAddress: map['pickupAddress'],
      pickupPoint: map['pickupPoint'],
      deliveryAddress: map['deliveryAddress'],
      deliveryPoint: map['deliveryPoint'],
      isUseBox: map['isUseBox'],
      boxType: map['boxType'],
      estimatedDistance: map['estimatedDistance'],
      total: map['total'],
      totalReal: map['totalReal'],
      estimatedDeliveryTime: map['estimatedDeliveryTime'],
      isDeposited: map['isDeposited'],
      isBonus: map['isBonus'],
      isReported: map['isReported'],
      reportedReason: map['reportedReason'],
      isDeleted: map['isDeleted'],
      createdAt: map['createdAt'],
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'],
      updatedBy: map['updatedBy'],
      review: map['review'],
      bonus: map['bonus'],
      typeBooking: map['typeBooking'],
      estimatedAcreage: map['estimatedAcreage'],
      roomNumber: map['roomNumber'],
      floorsNumber: map['floorsNumber'],
      isManyItems: map['isManyItems'],
      isCancel: map['isCancel'],
      cancelReason: map['cancelReason'],
      estimatedWeight: map['estimatedWeight'],
      estimatedHeight: map['estimatedHeight'],
      estimatedWidth: map['estimatedWidth'],
      estimatedLength: map['estimatedLength'],
      estimatedVolume: map['estimatedVolume'],
      isPorter: map['isPorter'],
      isRoundTrip: map['isRoundTrip'],
      note: map['note'],
      totalFee: map['totalFee'],
      feeInfo: map['feeInfo'],
      bookingTrackers: List<dynamic>.from(map['bookingTrackers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingEntities.fromJson(String source) =>
      BookingEntities.fromMap(json.decode(source));
}
