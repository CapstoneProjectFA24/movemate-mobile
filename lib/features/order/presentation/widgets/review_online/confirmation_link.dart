import 'package:flutter/material.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/widgets/voucher_modal/voucher_modal.dart';

class ConfirmationLink extends StatelessWidget {
  final List<VoucherEntity> vouchers;
  final List<VoucherEntity> selectedVouchers; // Thêm danh sách đã chọn
  // final VoidCallback onTap;
  final OrderEntity order;
  final Function(VoucherEntity) onVoucherSelected;
  final Function(VoucherEntity) onVoucherRemoved;
  const ConfirmationLink({
    super.key,
    required this.vouchers,
    required this.selectedVouchers,
    // required this.onTap,
    required this.order,
    required this.onVoucherSelected,
    required this.onVoucherRemoved, // Yêu cầu callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return VoucherModal(
              vouchers: vouchers,
              order: order,
              selectedVouchers: selectedVouchers, // Truyền danh sách đã chọn
              onVoucherUsed: onVoucherSelected,
              onVoucherCanceled:
                  onVoucherRemoved, // Truyền callback xuống VoucherModal
            );
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
