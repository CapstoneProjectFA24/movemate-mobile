import 'package:flutter/material.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class CouponInput extends StatelessWidget {
  final PaymentModelsCoupon paymentModelsCoupon;

  const CouponInput({
    super.key,
    required this.paymentModelsCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mã giảm giá',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: paymentModelsCoupon.couponHint,
            suffixIcon: TextButton(
              onPressed: () {
                // Xử lý khi thêm mã giảm giá
              },
              child: const Text(
                'Thêm',
                style: TextStyle(color: AssetsConstants.primaryDark),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
