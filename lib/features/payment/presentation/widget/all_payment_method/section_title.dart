import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PaymentMethodSection extends StatelessWidget {
  final String title;
  final List<Widget> methods;

  const PaymentMethodSection({
    required this.title,
    required this.methods,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AssetsConstants.blackColor,
            ),
          ),
        ),
        ...methods,
      ],
    );
  }
}
