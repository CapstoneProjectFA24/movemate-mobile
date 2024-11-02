// components/customer_info.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/order/presentation/widgets/details/infoItem.dart';

class CustomerInfo extends StatelessWidget {
  final ValueNotifier<bool> isExpanded;
  final VoidCallback toggleDropdown;

  const CustomerInfo({
    super.key,
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
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin liên hệ',
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
          const SizedBox(height: 10),
          if (isExpanded.value) ...[
            buildInfoItem('Họ và tên', 'NGUYEN VAN ANH'),
            buildInfoItem('Số điện thoại', '0900123456'),
            buildInfoItem('Email', 'nguyenvananh@gmail.com'),
          ],
        ],
      ),
    );
  }
}
