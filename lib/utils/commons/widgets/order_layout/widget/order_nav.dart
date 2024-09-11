import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class OrderNav extends StatelessWidget {
  const OrderNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AssetsConstants.primaryLight,
        ),
        onPressed: () {
          // Handle continue button press
          context.router.push(AvailableVehiclesScreenRoute());
        },
        child: const Text('Tiếp tục',
            style: TextStyle(fontSize: 16, color: AssetsConstants.whiteColor)),
      ),
    );
  }
}
