// selection_button.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool hasError; // New parameter to indicate error state

  const SelectionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.hasError = false, // Default to no error
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AssetsConstants.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasError
                ? Colors.red
                : AssetsConstants
                    .greyColor, // Change border color based on error
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: hasError
                    ? Colors.red
                    : AssetsConstants
                        .blackColor, // Change text color based on error
              ),
            ),
            Icon(icon, color: AssetsConstants.primaryDark),
          ],
        ),
      ),
    );
  }
}
