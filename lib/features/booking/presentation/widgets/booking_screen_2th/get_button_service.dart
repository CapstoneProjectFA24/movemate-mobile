import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';

class GetButtonService extends StatelessWidget {
  // final ValueChanged<[]> Service service;
  final int quantity;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const GetButtonService({
    super.key,
    required this.quantity,
    required this.addService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: ServiceTrailingWidget(
        quantity: quantity,
        addService: addService,
        onQuantityChanged: onQuantityChanged,
      ),
    );
  }
}
