import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SelectionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
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
          border: Border.all(color: AssetsConstants.greyColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AssetsConstants.blackColor,
              ),
            ),
            Icon(icon, color: AssetsConstants.primaryDark),
          ],
        ),
      ),
    );
  }
}
