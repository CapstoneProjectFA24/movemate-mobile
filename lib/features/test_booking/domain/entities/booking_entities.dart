import 'dart:convert';

class BookingEntities {
  final int id;
  final int userId;
  final double? deposit;
  final String? status;
  final String? pickupAddress;
  final String? pickupPoint;
  final String? deliveryAddress;
  final String? deliveryPoint;
  final bool? isUseBox;
  final String? boxType;
  final String? estimatedDistance;
  final double? total;
  final double? totalReal;
  final String? estimatedDeliveryTime;
  final bool? isDeposited;
  final bool? isBonus;
  final bool? isReported;
  final String? reportedReason;
  final bool? isDeleted;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? review;
  final String? bonus;
  final String? typeBooking;
  final double? estimatedAcreage;
  final String? roomNumber;
  final String? floorsNumber;
  final bool? isManyItems;
  final double? estimatedTotalWeight;
  final bool? isCancel;
  final String? cancelReason;
  final double? estimatedWeight;
  final double? estimatedHeight;
  final double? estimatedWidth;
  final double? estimatedLength;
  final double? estimatedVolume;
  final bool? isPorter;
  final bool? isRoundTrip;
  final String? note;
  final double? totalFee;
  final String? feeInfo;
  final List<dynamic>? bookingTrackers;

  BookingEntities({
    required this.id,
    required this.userId,
    this.deposit,
    this.status,
    this.pickupAddress,
    this.pickupPoint,
    this.deliveryAddress,
    this.deliveryPoint,
    this.isUseBox,
    this.boxType,
    this.estimatedDistance,
    this.total,
    this.totalReal,
    this.estimatedDeliveryTime,
    this.isDeposited,
    this.isBonus,
    this.isReported,
    this.reportedReason,
    this.isDeleted,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.review,
    this.bonus,
    this.typeBooking,
    this.estimatedAcreage,
    this.roomNumber,
    this.floorsNumber,
    this.isManyItems,
    this.estimatedTotalWeight,
    this.isCancel,
    this.cancelReason,
    this.estimatedWeight,
    this.estimatedHeight,
    this.estimatedWidth,
    this.estimatedLength,
    this.estimatedVolume,
    this.isPorter,
    this.isRoundTrip,
    this.note,
    this.totalFee,
    this.feeInfo,
    this.bookingTrackers,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'deposit': deposit});
    result.addAll({'status': status});
    result.addAll({'pickupAddress': pickupAddress});
    result.addAll({'pickupPoint': pickupPoint});
    result.addAll({'deliveryAddress': deliveryAddress});
    result.addAll({'deliveryPoint': deliveryPoint});
    result.addAll({'isUseBox': isUseBox});
    result.addAll({'boxType': boxType});
    result.addAll({'estimatedDistance': estimatedDistance});
    result.addAll({'total': total});
    result.addAll({'totalReal': totalReal});
    result.addAll({'estimatedDeliveryTime': estimatedDeliveryTime});
    result.addAll({'isDeposited': isDeposited});
    result.addAll({'isBonus': isBonus});
    result.addAll({'isReported': isReported});
    result.addAll({'reportedReason': reportedReason});
    result.addAll({'isDeleted': isDeleted});
    result.addAll({'createdAt': createdAt?.toIso8601String()});
    result.addAll({'createdBy': createdBy});
    result.addAll({'updatedAt': updatedAt?.toIso8601String()});
    result.addAll({'updatedBy': updatedBy});
    result.addAll({'review': review});
    result.addAll({'bonus': bonus});
    result.addAll({'typeBooking': typeBooking});
    result.addAll({'estimatedAcreage': estimatedAcreage});
    result.addAll({'roomNumber': roomNumber});
    result.addAll({'floorsNumber': floorsNumber});
    result.addAll({'isManyItems': isManyItems});
    result.addAll({'estimatedTotalWeight': estimatedTotalWeight});
    result.addAll({'isCancel': isCancel});
    result.addAll({'cancelReason': cancelReason});
    result.addAll({'estimatedWeight': estimatedWeight});
    result.addAll({'estimatedHeight': estimatedHeight});
    result.addAll({'estimatedWidth': estimatedWidth});
    result.addAll({'estimatedLength': estimatedLength});
    result.addAll({'estimatedVolume': estimatedVolume});
    result.addAll({'isPorter': isPorter});
    result.addAll({'isRoundTrip': isRoundTrip});
    result.addAll({'note': note});
    result.addAll({'totalFee': totalFee});
    result.addAll({'feeInfo': feeInfo});
    result.addAll({'bookingTrackers': bookingTrackers});

    return result;
  }

  factory BookingEntities.fromMap(Map<String, dynamic> map) {
    return BookingEntities(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      deposit:
          map['deposit'] != null ? (map['deposit'] as num).toDouble() : null,
      status: map['status'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      isUseBox: map['isUseBox'] ?? false,
      boxType: map['boxType'] ?? '',
      estimatedDistance: map['estimatedDistance'] ?? '',
      total: map['total'] != null ? (map['total'] as num).toDouble() : null,
      totalReal: map['totalReal'] != null
          ? (map['totalReal'] as num).toDouble()
          : null,
      estimatedDeliveryTime: map['estimatedDeliveryTime'] ?? '',
      isDeposited: map['isDeposited'] ?? false,
      isBonus: map['isBonus'] ?? false,
      isReported: map['isReported'] ?? false,
      reportedReason: map['reportedReason'] ?? '',
      isDeleted: map['isDeleted'] ?? false,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      createdBy: map['createdBy'] ?? '',
      updatedAt:
          map['updatedAt'] != null && map['updatedAt'] != '0001-01-01T00:00:00'
              ? DateTime.parse(map['updatedAt'])
              : null,
      updatedBy: map['updatedBy'] ?? '',
      review: map['review'] ?? '',
      bonus: map['bonus'] ?? '',
      typeBooking: map['typeBooking'] ?? '',
      estimatedAcreage: map['estimatedAcreage'] != null
          ? (map['estimatedAcreage'] as num).toDouble()
          : null,
      roomNumber: map['roomNumber'] ?? '',
      floorsNumber: map['floorsNumber'] ?? '',
      isManyItems: map['isManyItems'] ?? false,
      estimatedTotalWeight: map['estimatedTotalWeight'] != null
          ? (map['estimatedTotalWeight'] as num).toDouble()
          : null,
      isCancel: map['isCancel'] ?? false,
      cancelReason: map['cancelReason'] ?? '',
      estimatedWeight: map['estimatedWeight'] != null
          ? (map['estimatedWeight'] as num).toDouble()
          : null,
      estimatedHeight: map['estimatedHeight'] != null
          ? (map['estimatedHeight'] as num).toDouble()
          : null,
      estimatedWidth: map['estimatedWidth'] != null
          ? (map['estimatedWidth'] as num).toDouble()
          : null,
      estimatedLength: map['estimatedLength'] != null
          ? (map['estimatedLength'] as num).toDouble()
          : null,
      estimatedVolume: map['estimatedVolume'] != null
          ? (map['estimatedVolume'] as num).toDouble()
          : null,
      isPorter: map['isPorter'] ?? false,
      isRoundTrip: map['isRoundTrip'] ?? false,
      note: map['note'] ?? '',
      totalFee:
          map['totalFee'] != null ? (map['totalFee'] as num).toDouble() : null,
      feeInfo: map['feeInfo'] ?? '',
      bookingTrackers: map['bookingTrackers'] != null
          ? List<dynamic>.from(map['bookingTrackers'])
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  // @override
  // String toString() {
  //   return 'BookingEntities{id: $id, userId: $userId, deposit: $deposit, status: $status, pickupAddress: $pickupAddress, pickupPoint: $pickupPoint, deliveryAddress: $deliveryAddress, deliveryPoint: $deliveryPoint, isUseBox: $isUseBox, boxType: $boxType, estimatedDistance: $estimatedDistance, total: $total, totalReal: $totalReal, estimatedDeliveryTime: $estimatedDeliveryTime, isDeposited: $isDeposited, isBonus: $isBonus, isReported: $isReported, reportedReason: $reportedReason, isDeleted: $isDeleted, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy, review: $review, bonus: $bonus, typeBooking: $typeBooking, estimatedAcreage: $estimatedAcreage, roomNumber: $roomNumber, floorsNumber: $floorsNumber, isManyItems: $isManyItems, estimatedTotalWeight: $estimatedTotalWeight, isCancel: $isCancel, cancelReason: $cancelReason, estimatedWeight: $estimatedWeight, estimatedHeight: $estimatedHeight, estimatedWidth: $estimatedWidth, estimatedLength: $estimatedLength, estimatedVolume: $estimatedVolume, isPorter: $isPorter, isRoundTrip: $isRoundTrip, note: $note, totalFee: $totalFee, feeInfo: $feeInfo, bookingTrackers: $bookingTrackers}';
  // }

  factory BookingEntities.fromJson(String source) =>
      BookingEntities.fromMap(json.decode(source));
}
