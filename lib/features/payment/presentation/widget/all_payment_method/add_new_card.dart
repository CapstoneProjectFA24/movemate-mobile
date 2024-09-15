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
            width: 40,
            height: 40,
            child: Image.asset(
              iconPath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Thêm thẻ mới',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AssetsConstants.blackColor,
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
            color: AssetsConstants.primaryDark,
          ),
        ),
      ),
    );
  }
}
