import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import '../../../../../configs/routes/app_router.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/constants/asset_constant.dart';

class OrderItem extends HookConsumerWidget {
  const OrderItem({
    super.key,
    required this.order,
    required this.onCallback,
  });

  final OrderEntity order;
  final VoidCallback onCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    int displayTotal;
    if (order.status == 'DEPOSITING') {
      displayTotal = order.deposit;
    } else if (order.status == 'Pending') {
      displayTotal = order.total;
    } else {
      displayTotal = 0;
    }

    String formattedTotal = NumberFormat('#,###').format(displayTotal);

    return GestureDetector(
      onTap: () {
        context.router.push(OrderDetailsScreenRoute(order: order));
      },
      child: Container(
        width: 380,
        height: 140,
        padding: const EdgeInsets.all(AssetsConstants.defaultPadding - 12.0),
        margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://storage.googleapis.com/a1aa/image/fpR5CaQW2ny0CCt8MBn1ufzjTBuLAgHXz4yQMiYIxzaWDIlTA.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15), // Space between image and content
            // Card Content
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      content: 'Mã đơn hàng : #${order.id}',
                      size: AssetsConstants.defaultFontSize - 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        LabelText(
                          content: 'Loại nhà: ',
                          size: AssetsConstants.defaultFontSize - 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                        Text(
                          'Nhà riêng',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Status
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration:  BoxDecoration(
                             color: order.status == 'DEPOSITING'
            ? Colors.red
            : order.status == 'Pending'
                ? Colors.orange
                : const Color(0xFF28A745), // Màu mặc định
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(order.status),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          // ' ${(NumberFormat('#,###').format(order.total) ?? 0)} ₫',
                          '$formattedTotal ₫',
                          style: const TextStyle(
                              color: Color(0xFF007BFF),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '• ${order.roomNumber} - ${order.floorsNumber} tầng ',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF555555)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
