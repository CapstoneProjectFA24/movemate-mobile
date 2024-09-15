import 'package:flutter/material.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';

class TotalPrice extends StatelessWidget {
  final PaymentModelsTotalPrice paymentModelsTotalPrice;

  const TotalPrice({
    super.key,
    required this.paymentModelsTotalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tổng giá tiền',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          paymentModelsTotalPrice.totalPrice,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
