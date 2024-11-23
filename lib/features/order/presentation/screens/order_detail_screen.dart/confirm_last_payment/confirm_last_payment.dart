import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

@RoutePage()
class ConfirmLastPayment extends HookConsumerWidget {
  final OrderEntity? orderObj;
  final int id;
  const ConfirmLastPayment(
      {super.key, required this.orderObj, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Xác nhận nghiệm thu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://storage.googleapis.com/a1aa/image/lRXLqEBxKhosBVsx6qyoZyZbHgEKmzfl0LRybpjShblvC75JA.jpg',
                    height: 150,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                            '172 Phạm Ngũ Lão, Hùng Vương, Bình Tân, Hồ Chí Minh'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Text('194 Cao Lãnh, Hùng Vương, Tân Phú, Hồ Chí Minh'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Chi tiết đơn hàng',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const _OrderItem(
                label: 'Bốc xếp (Bởi nhân viên bốc xếp)',
                price: '400.000 đ',
              ),
              const _OrderItem(
                label: 'Tháo lắp, đóng gói máy lạnh',
                price: '300.000 đ',
              ),
              const _OrderItem(
                label: 'Xe tải 1000kg',
                price: '149.500 đ',
              ),
              const _OrderItem(
                label: 'Chứng từ điện tử',
                price: '5.000 đ',
              ),
              const _OrderItem(
                label: 'Hỗ trợ nhân viên bốc xếp',
                price: '9.600 đ',
              ),
              const _OrderItem(
                label: 'Tổng giá',
                price: '963.100 đ',
                isBold: true,
              ),
              const SizedBox(height: 16),
              const _SummaryItem(
                label: 'Ghi chú:',
                value: 'Không có',
              ),
              const _SummaryItem(
                label: 'Mã đơn hàng:',
                value: '#6',
              ),
              const _SummaryItem(
                label: 'Thời gian vận chuyển:',
                value: '22/11/2024 09:30',
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirmation button press
                    context.pushRoute(LastPaymentScreenRoute(
                      id: id,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    iconColor: Colors.yellow[700],
                    side: BorderSide(color: Colors.yellow[700]!),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận hoàn thành',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String label;
  final String price;
  final bool isBold;

  const _OrderItem({
    super.key,
    required this.label,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            price,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
