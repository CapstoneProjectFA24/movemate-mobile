import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class RoomFloorCountButton extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onTap;

  const RoomFloorCountButton({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AssetsConstants.greyColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AssetsConstants.greyColor,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: AssetsConstants.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AssetsConstants.blackColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down,
                    color: AssetsConstants.primaryDark),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
