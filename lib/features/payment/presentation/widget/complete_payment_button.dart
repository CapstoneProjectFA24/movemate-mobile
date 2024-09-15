import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class CompletePaymentButton extends StatelessWidget {
  const CompletePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6F00),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () {
          // Xử lý khi bấm hoàn tất thanh toán
        },
        child: const Text(
          'Hoàn tất thanh toán bằng MoMo E-Wallet',
          style: TextStyle(
            fontSize: 16,
            color: AssetsConstants.whiteColor,
          ),
        ),
      ),
    );
  }
}
