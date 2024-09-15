import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class AddNewCardComponent extends StatelessWidget {
  final String iconPath;

  const AddNewCardComponent({required this.iconPath, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            width: 40, // Fixed width
            height: 40, // Fixed height
            child: Image.asset(
              iconPath,
              width: 40, // Set image width
              height: 40, // Set image height
              fit: BoxFit.cover, // Ensure the image fits within the box
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Thêm thẻ mới',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AssetsConstants.blackColor, // Text color in black
              ),
            ),
          ),
        ],
      ),
      trailing: TextButton(
        onPressed: () {
          // Handle add new card action
        },
        child: const Text(
          'Thêm',
          style: TextStyle(
            color: AssetsConstants.primaryDark, // Orange text for "Thêm"
          ),
        ),
      ),
    );
  }
}
