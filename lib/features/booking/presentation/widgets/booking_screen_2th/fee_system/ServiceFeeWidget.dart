import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_modal_infor.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';

class ServiceFeeWidget extends StatelessWidget {
  final ServicesFeeSystemEntity serviceFee;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const ServiceFeeWidget({
    super.key,
    required this.serviceFee,
    this.addService = true,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.local_shipping, color: Colors.green),
      title: Row(
        children: [
          Expanded(
            child: LabelText(
              content: serviceFee.name,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blue),
            onPressed: () {
              // Show the modal when the info icon is tapped
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7, // 70% of the screen height
                    child: ServiceInfoModal(
                      title: serviceFee.name,
                      // infoText: serviceFee.description ?? 'No additional information.',
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      subtitle: Text(
        '${serviceFee.amount}',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: ServiceTrailingWidget(
        quantity: 1, // You might want to manage this dynamically
        addService: addService,
        onQuantityChanged: onQuantityChanged,
      ),
    );
  }
}
