import 'package:flutter/material.dart';
import 'package:movemate/features/order/presentation/vehicles_available_screen.dart';
import 'package:movemate/features/order/domain/models/order_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class OrderNav extends StatelessWidget {
  const OrderNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to AvailableVehiclesScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AvailableVehiclesScreen(
                avalble: AvailableVehicles(
                  initialSelectedVehicleIndex: 0, // Example initial index
                  initialTotalPrice: 300000, // Example initial price
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Tiếp tục',
          style: TextStyle(
            fontSize: 16,
            color: AssetsConstants.whiteColor,
          ),
        ),
      ),
    );
  }
}
