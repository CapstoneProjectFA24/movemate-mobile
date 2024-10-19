import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class CompletePaymentButton extends StatelessWidget {
  final String selectedPaymentMethod; // Nhận phương thức thanh toán hiện tại

  const CompletePaymentButton({
    super.key,
    required this.selectedPaymentMethod, // Truyền giá trị vào constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AssetsConstants.primaryDark,
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () {
          // Xử lý khi bấm hoàn tất thanh toán
        },
        child: Text(
          'Hoàn tất thanh toán bằng $selectedPaymentMethod',
          style: const TextStyle(
            fontSize: 16,
            color: AssetsConstants.whiteColor,
          ),
        ),

      ),
    );
  }
}
