import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'có gì hot',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          Image.asset(
            AssetsConstants.hot,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
