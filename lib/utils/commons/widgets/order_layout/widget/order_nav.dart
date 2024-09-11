//order_nav.dart
import 'package:flutter/material.dart';
import 'package:movemate/features/order/presentation/vehicles_available_screen.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class OrderNav extends StatelessWidget {
  const OrderNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle continue button press
          const AvailableVehiclesScreen();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Tiếp tục',
            style: TextStyle(fontSize: 16, color: AssetsConstants.whiteColor)),
      ),
    );
  }
}
