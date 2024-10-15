import 'package:movemate/features/booking/data/models/resquest/booking_requesst.dart';
import 'package:movemate/features/booking/data/models/resquest/services_detail_request.dart';
import 'package:movemate/features/booking/domain/entities/vinh/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/vinh/service_entity.dart';

class BookingEntity extends BookingRequesst {
  final double? totalPrice;
  final HouseTypeEntity? houseType;
  final List<ServiceEntity>? services;

  BookingEntity({
    required super.pickupAddress,
    required super.pickupPoint,
    required super.deliveryAddress,
    required super.deliveryPoint,
    required super.estimatedDistance,
    required super.houseTypeId,
    required super.note,
    required super.estimatedDeliveryTime,
    required super.isRoundTrip,
    required super.isManyItems,
    required super.roomNumber,
    required super.floorsNumber,
    required super.serviceDetails,
    required super.truckCategoryId,
    required super.bookingAt,
    this.totalPrice,
    this.houseType,
    this.services,
  });

  factory BookingEntity.fromRequest(BookingRequesst request) {
    return BookingEntity(
      pickupAddress: request.pickupAddress,
      pickupPoint: request.pickupPoint,
      deliveryAddress: request.deliveryAddress,
      deliveryPoint: request.deliveryPoint,
      estimatedDistance: request.estimatedDistance,
      houseTypeId: request.houseTypeId,
      note: request.note,
      estimatedDeliveryTime: request.estimatedDeliveryTime,
      isRoundTrip: request.isRoundTrip,
      isManyItems: request.isManyItems,
      roomNumber: request.roomNumber,
      floorsNumber: request.floorsNumber,
      serviceDetails: request.serviceDetails,
      truckCategoryId: request.truckCategoryId,
      bookingAt: request.bookingAt,
    );
  }

  BookingEntity copyWith({
    String? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalPrice,
    String? customerId,
    String? driverId,
    String? pickupAddress,
    String? pickupPoint,
    String? deliveryAddress,
    String? deliveryPoint,
    String? estimatedDistance,
    int? houseTypeId,
    String? note,
    String? estimatedDeliveryTime,
    bool? isRoundTrip,
    bool? isManyItems,
    String? roomNumber,
    String? floorsNumber,
    int? truckCategoryId,
    DateTime? bookingAt,
    HouseTypeEntity? houseType,
    List<ServicesDetailRequest>? serviceDetails,
      List<ServiceEntity>? services,
  }) {
    return BookingEntity(
      totalPrice: totalPrice ?? this.totalPrice,
      services: services ?? services,
      houseType: houseType ?? houseType,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryPoint: deliveryPoint ?? this.deliveryPoint,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      houseTypeId: houseTypeId ?? this.houseTypeId,
      note: note ?? this.note,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      isManyItems: isManyItems ?? this.isManyItems,
      roomNumber: roomNumber ?? this.roomNumber,
      floorsNumber: floorsNumber ?? this.floorsNumber,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      truckCategoryId: truckCategoryId ?? this.truckCategoryId,
      bookingAt: bookingAt ?? this.bookingAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'totalPrice': totalPrice,
      'houseType': houseType?.toJson(),
      'services': services?.map((service) => service.toJson()).toList(),
    });
    return map;
  }

  factory BookingEntity.fromMap(Map<String, dynamic> map) {
    final request = BookingRequesst.fromMap(map);
    return BookingEntity(
      houseType: map['houseType'] != null
          ? HouseTypeEntity.fromJson(map['houseType'])
          : null,
      totalPrice: map['totalPrice']?.toDouble(),
      services: map['services'] != null
          ? (map['services'] as List)
              .map((serviceMap) => ServiceEntity.fromJson(serviceMap))
              .toList()
          : null,
      ///////////////////////////////
      pickupAddress: request.pickupAddress,
      pickupPoint: request.pickupPoint,
      deliveryAddress: request.deliveryAddress,
      deliveryPoint: request.deliveryPoint,
      estimatedDistance: request.estimatedDistance,
      houseTypeId: request.houseTypeId,
      note: request.note,
      estimatedDeliveryTime: request.estimatedDeliveryTime,
      isRoundTrip: request.isRoundTrip,
      isManyItems: request.isManyItems,
      roomNumber: request.roomNumber,
      floorsNumber: request.floorsNumber,
      serviceDetails: request.serviceDetails,
      truckCategoryId: request.truckCategoryId,
      bookingAt: request.bookingAt,
    );
  }
}
