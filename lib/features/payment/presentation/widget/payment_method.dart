import 'package:flutter/material.dart';
import 'package:movemate/features/payment/presentation/screens/payment_all_method_screen.dart';

import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PaymentMethod extends StatelessWidget {
  final PaymentModelsMethod paymentModelsMethod;
  final void Function(String) onMethodChanged;
  final List<PaymentModelsMethod> paymentMethods;

  const PaymentMethod({
    super.key,
    required this.paymentModelsMethod,
    required this.onMethodChanged,
    required this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Phương thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Show bottom modal with SeeAllPaymentMethod
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return const SeeAllPaymentMethodScreen();
                  },
                );
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 16,
                  color: AssetsConstants.primaryLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: paymentMethods.map((method) {
            return GestureDetector(
              onTap: () {
                onMethodChanged(method.methodName);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: paymentModelsMethod.methodName == method.methodName
                      ? AssetsConstants.greyColor.shade200
                      : AssetsConstants.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: paymentModelsMethod.methodName == method.methodName
                        ? AssetsConstants.blue1
                        : AssetsConstants.greyColor.shade300,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        method.imageAssetPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        method.methodName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio<String>(
                      value: method.methodName,
                      groupValue: paymentModelsMethod.methodName,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onMethodChanged(newValue);
                        }
                      },
                      activeColor: AssetsConstants.blue1,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
