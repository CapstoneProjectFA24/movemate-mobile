import 'package:flutter/material.dart';
import 'package:movemate/features/promotion/presentation/widgets/voucher_modal/voucher_modal.dart';

class ConfirmationLink extends StatelessWidget {
  final List<String> vouchers;
  final VoidCallback onTap;

  const ConfirmationLink({
    super.key,
    required this.vouchers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return VoucherModal(vouchers: vouchers);
          },
        );
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phiếu giảm giá có trong đơn hàng',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
