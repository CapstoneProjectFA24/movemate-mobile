// components/customer_info.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';

class CustomerInfo extends StatelessWidget {
  final ValueNotifier<bool> isExpanded;
  final VoidCallback toggleDropdown;
  final OrderEntity order;
  const CustomerInfo({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.toggleDropdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin dịch vụ cũ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded.value
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.black54,
                ),
                onPressed: toggleDropdown,
              ),
            ],
          ),
//hiển thị data cũ truyền order cũ vào
          if (isExpanded.value)
            ...order.bookingDetails.map<Widget>((detail) {
              return buildPriceItem(
                detail.name ?? '',
                formatPrice(detail.price.toInt()),
              );
            }),
        ],
      ),
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
