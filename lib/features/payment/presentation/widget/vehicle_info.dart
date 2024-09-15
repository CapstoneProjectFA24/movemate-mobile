import 'package:flutter/material.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class VehicleInfo extends StatelessWidget {
  final PaymentModelsVehicleInfo paymentModelsVehicleInfo;

  const VehicleInfo({
    super.key,
    required this.paymentModelsVehicleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thông tin xe và số lượng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              paymentModelsVehicleInfo.struckName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              paymentModelsVehicleInfo.quantity,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Ngày
        Text(
          paymentModelsVehicleInfo.date,
          style: const TextStyle(
            fontSize: 16,
            color: AssetsConstants.greyColor,
          ),
        ),
      ],
    );
  }
}
