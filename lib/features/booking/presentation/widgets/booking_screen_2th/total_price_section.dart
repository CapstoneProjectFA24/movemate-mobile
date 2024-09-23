// total_price_section.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class TotalPriceSection extends StatelessWidget {
  final double totalPrice;
  final bool isButtonEnabled;
  final VoidCallback onButtonPressed;

  const TotalPriceSection({
    super.key,
    required this.totalPrice,
    required this.isButtonEnabled,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade300,
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts height to fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng', style: TextStyle(fontSize: 16)),
                Text(
                  '₫${totalPrice.toStringAsFixed(0)} ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? onButtonPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? AssetsConstants.primaryDark
                      : AssetsConstants.greyColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Bước tiếp theo',
                  style: TextStyle(
                    fontSize: 16,
                    color: AssetsConstants.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
