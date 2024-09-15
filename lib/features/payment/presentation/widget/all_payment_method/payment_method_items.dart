import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PaymentMethodItem extends HookConsumerWidget {
  final PaymentModelsSeeAllPaymentMethodItems paymentModelsitems;

  const PaymentMethodItem({
    super.key,
    required this.paymentModelsitems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod =
        useValueListenable(paymentModelsitems.selectedMethod);

    return RadioListTile<String>(
      value: paymentModelsitems.methodValue,
      groupValue: selectedMethod,
      activeColor: AssetsConstants.blue1,
      onChanged: (String? value) {
        paymentModelsitems.selectedMethod.value = value!;
      },
      title: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              paymentModelsitems.iconPath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentModelsitems.methodName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AssetsConstants.blackColor,
                  ),
                ),
                if (paymentModelsitems.linkedText.isNotEmpty)
                  Text(
                    paymentModelsitems.linkedText,
                    style: TextStyle(
                      fontSize: 12,
                      color: paymentModelsitems.isLinked
                          ? AssetsConstants.blue1
                          : AssetsConstants.greyColor,
                    ),
                  ),
                if (paymentModelsitems.additionalText != null)
                  Text(
                    paymentModelsitems.additionalText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AssetsConstants.blue1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
