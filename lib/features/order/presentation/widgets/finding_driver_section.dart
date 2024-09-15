import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class FindingDriverSection extends HookWidget {
  final AnimationController controller;

  const FindingDriverSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AssetsConstants.whiteColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(2.0),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.delivery_dining,
                    color: AssetsConstants.primaryLight, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đang tìm tài xế',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AssetsConstants.primaryLight),
                  ),
                ),
                Icon(Icons.phone_iphone,
                    size: 40, color: AssetsConstants.warningColor),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'MoveMate sẽ gửi thông tin tài xế đến bạn\nkhi tìm thấy tài xế phù hợp',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            // Progress bar with animation
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: controller.value, // Animate the progress bar
                  backgroundColor: AssetsConstants.greyColor.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AssetsConstants.primaryLight),
                );
              },
            ),
            const SizedBox(height: 12),
            // Custom delivery progress steps
            _buildProgressSteps(),
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                child: Text(
                  "Movemate sẽ gửi thông báo khi tài xế bắt đầu đi đến bạn",
                  style: TextStyle(color: AssetsConstants.greyColor.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the custom progress steps
  Widget _buildProgressSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepItem(
          icon: Icons.restaurant,
          isActive: true,
        ),
        const Expanded(
          child: Divider(
            color: AssetsConstants.warningColor,
            thickness: 2,
          ),
        ),
        _buildStepItem(
          icon: Icons.local_shipping,
          isActive: true,
        ),
        const Expanded(
          child: Divider(
            color: AssetsConstants.greyColor,
            thickness: 2,
          ),
        ),
        _buildStepItem(
          icon: Icons.directions_bike,
          isActive: false,
        ),
        const Expanded(
          child: Divider(
            color: AssetsConstants.greyColor,
            thickness: 2,
          ),
        ),
        _buildStepItem(
          icon: Icons.home,
          isActive: false,
        ),
      ],
    );
  }

  // Helper function to build each step icon
  Widget _buildStepItem({required IconData icon, required bool isActive}) {
    return Icon(
      icon,
      color:
          isActive ? AssetsConstants.warningColor : AssetsConstants.greyColor,
      size: 30,
    );
  }
}
