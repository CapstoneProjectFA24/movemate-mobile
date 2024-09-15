import 'package:flutter/material.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PaymentDeadline extends StatelessWidget {
  final PaymentModelsDeadline paymentModelsDeadline;

  const PaymentDeadline({
    super.key,
    required this.paymentModelsDeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.access_time, color: Colors.blue),
        const SizedBox(width: 8),
        const Text(
          'Thanh toán trong thời hạn',
          style: TextStyle(
            fontSize: 16,
            color: AssetsConstants.blue1,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              paymentModelsDeadline.hours,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(':'),
            Text(
              paymentModelsDeadline.minutes,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(':'),
            Text(
              paymentModelsDeadline.seconds,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
