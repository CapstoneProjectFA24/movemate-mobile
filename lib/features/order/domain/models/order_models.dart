import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderState {
  final bool isFindingDriver;
  final String? driverName;
  final String? driverRating;
  final String? driverLicensePlate;

  OrderState({
    this.isFindingDriver = true,
    this.driverName,
    this.driverRating,
    this.driverLicensePlate,
  });

  OrderState copyWith({
    bool? isFindingDriver,
    String? driverName,
    String? driverRating,
    String? driverLicensePlate,
  }) {
    return OrderState(
      isFindingDriver: isFindingDriver ?? this.isFindingDriver,
      driverName: driverName ?? this.driverName,
      driverRating: driverRating ?? this.driverRating,
      driverLicensePlate: driverLicensePlate ?? this.driverLicensePlate,
    );
  }
}

class OrderDriverArrivedSectionModels {
  final String? driverName;
  final String? driverRating;
  final String? driverLicensePlate;
  final String? driverImage;

  OrderDriverArrivedSectionModels({
    required this.driverName,
    required this.driverRating,
    required this.driverLicensePlate,
    required this.driverImage,
  });
}

class OrderAndDeliveryInfoModel {
  final String orderDetails;
  final String deliveryAddress;
  final String receiverDetails;
  final String userName;
  final String numberPhone;

  OrderAndDeliveryInfoModel({
    required this.orderDetails,
    required this.deliveryAddress,
    required this.receiverDetails,
    required this.userName,
    required this.numberPhone,
  });
}

class PaymentInfoModel {
  final String paymentMethod;
  final String paymentAmount;
  final String orderId;
  final String orderTime;
  final String distance;
  final String vehicleType;
  PaymentInfoModel({
    required this.paymentMethod,
    required this.paymentAmount,
    required this.orderId,
    required this.orderTime,
    required this.distance,
    required this.vehicleType,
  });
}

class OrderDetailsAndCancelModel {
  final bool isFindingDriver;

  OrderDetailsAndCancelModel({
    required this.isFindingDriver,
  });
}
