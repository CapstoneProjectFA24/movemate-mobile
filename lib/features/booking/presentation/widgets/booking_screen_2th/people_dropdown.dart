import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PeopleDropdown extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const PeopleDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Nút giảm số lượng
        IconButton(
          icon: const Icon(Icons.remove_circle_outline,
              color: AssetsConstants.primaryLight),
          onPressed: () {
            if (selectedValue > 1) {
              // Đảm bảo không giảm xuống dưới 1
              onChanged(selectedValue - 1); // Giảm giá trị khi nhấn nút
            }
          },
        ),
        // Hiển thị số người
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AssetsConstants.greyColor.shade300),
            color: AssetsConstants.whiteColor,
          ),
          child: Text(
            '$selectedValue', // Hiển thị số lượng người hiện tại
            style: const TextStyle(fontSize: 18),
          ),
        ),
        // Nút tăng số lượng
        IconButton(
          icon: const Icon(Icons.add_circle_outline,
              color: AssetsConstants.primaryLighter),
          onPressed: () {
            onChanged(selectedValue + 1); // Tăng giá trị khi nhấn nút
          },
        ),
      ],
    );
  }
}
