import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class AddButtonService extends StatelessWidget {
  final String title;
  final String price;
  final IconData icon;
  final int quantity;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const AddButtonService({
    super.key,
    required this.title,
    required this.price,
    required this.icon,
    required this.quantity,
    required this.addService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: LabelText(
        content: title,
        size: 14,
        fontWeight: FontWeight.w600,
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
