//booking_dropdown_button.dart
import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class BookingDropdownButton extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onPressed;

  const BookingDropdownButton({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        backgroundColor: AssetsConstants.whiteColor,
        foregroundColor: AssetsConstants.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color:
                isExpanded ? AssetsConstants.blue1 : AssetsConstants.greyColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ],
      ),
    );
  }
}
