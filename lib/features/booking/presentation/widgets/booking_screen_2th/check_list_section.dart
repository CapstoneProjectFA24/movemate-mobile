//check_list-section.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ChecklistSection extends StatelessWidget {
  final List<String> checklistOptions;
  final List<bool> checklistValues;
  final ValueChanged<int> onChanged;

  const ChecklistSection({
    super.key,
    required this.checklistOptions,
    required this.checklistValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hướng dẫn chuyển nhà',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: checklistOptions.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              value: checklistValues[index],
              title: Text(
                checklistOptions[index],
                style: const TextStyle(
                  color: AssetsConstants.blackColor,
                ),
              ),
              onChanged: (value) {
                onChanged(index);
              },
            );
          },
        ),
      ],
    );
  }
}
