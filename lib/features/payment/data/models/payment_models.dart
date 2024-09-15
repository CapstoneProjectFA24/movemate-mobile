import 'package:flutter/material.dart';

class PaymentModelsVehicleInfo {
  final String struckName;
  final String quantity;
  final String date;

  PaymentModelsVehicleInfo({
    required this.struckName,
    required this.quantity,
    required this.date,
  });
}

class PaymentModelsDeadline {
  final String hours;
  final String minutes;
  final String seconds;

  PaymentModelsDeadline({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}

class PaymentModelsMethod {
  final String methodName;
  final String imageAssetPath;
  // final List<PaymentModelsMethod> paymentMethodsList;

  PaymentModelsMethod({
    required this.methodName,
    required this.imageAssetPath,
    // required this.paymentMethodsList,
  });
}

class PaymentModelsCoupon {
  final String couponHint;

  PaymentModelsCoupon({
    required this.couponHint,
  });
}

class PaymentModelsTotalPrice {
  final String totalPrice;

  PaymentModelsTotalPrice({
    required this.totalPrice,
  });
}

class PaymentModelsSeeAllPaymentMethodItems {
  final String iconPath;
  final String methodName;
  final bool isLinked;
  final String linkedText;
  final String methodValue;
  final ValueNotifier<String> selectedMethod;
  final String? additionalText;

  const PaymentModelsSeeAllPaymentMethodItems({
    required this.iconPath,
    required this.methodName,
    required this.isLinked,
    required this.linkedText,
    required this.methodValue,
    required this.selectedMethod,
    this.additionalText,
  });
}
