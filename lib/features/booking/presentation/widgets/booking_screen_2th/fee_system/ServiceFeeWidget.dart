import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceFeeWidget extends StatelessWidget {
  final ServicesFeeSystemEntity serviceFee;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const ServiceFeeWidget({
    super.key,
    required this.serviceFee,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AssetsConstants.greyColor.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Giữ cho nền của Material trong suốt
        child: ListTile(
          leading: const Icon(Icons.local_shipping, color: Colors.green),
          title: Row(
            children: [
              Expanded(
                child: LabelText(
                  content: serviceFee.name,
                  size: 14,
                  fontWeight: FontWeight.w600,
                  color: AssetsConstants.blackColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.blue),
                onPressed: () {
                  // Hiển thị thông tin chi tiết khi nhấn vào icon
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   builder: (BuildContext context) {
                  //     return FractionallySizedBox(
                  //       heightFactor: 0.7,
                  //       child: ServiceInfoModal(
                  //         title: serviceFee.name,
                  //         infoText: serviceFee.description ??
                  //             'Không có thông tin thêm.',
                  //       ),
                  //     );
                  //   },
                  // );
                },
              ),
            ],
          ),
          subtitle: Text(
            'Giá: \$${serviceFee.amount}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: ServiceTrailingWidget(
            addService: false,
            quantity: quantity,
            onQuantityChanged: onQuantityChanged,
          ),
        ),
      ),
    );
  }
}
