import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_modal_infor.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class AddButtonService extends StatelessWidget {
  final String title;
  final String price;
  final IconData icon;
  final String imagePath;
  final int quantity;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const AddButtonService({
    super.key,
    required this.title,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.quantity,
    required this.addService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Row(
        children: [
          Expanded(
            child: LabelText(
              content: title,
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
                    heightFactor: 0.7, // Half of the screen height
                    child: ServiceInfoModal(
                      title: title,
                      // infoText: infoText,
                      imagePath: imagePath,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      subtitle:
          Text(price, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: ServiceTrailingWidget(
        quantity: quantity,
        addService: addService,
        onQuantityChanged: onQuantityChanged,
      ),
    );
  }
}
