import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AssetsConstants.green1
                  : AssetsConstants.greyColor.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? AssetsConstants.green1.withOpacity(0.1)
                : AssetsConstants.whiteColor,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? AssetsConstants.green1
                    : AssetsConstants.greyColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AssetsConstants.green1
                        : AssetsConstants.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}