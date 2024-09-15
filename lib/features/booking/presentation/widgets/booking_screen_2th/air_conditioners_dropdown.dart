//Air_Conditioners_Dropdown.dart
import 'package:flutter/material.dart';

class AirConditionersDropdown extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const AirConditionersDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<int>(
        isDense: false,
        isExpanded: false,
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        value: selectedValue,
        items: List.generate(
          10,
          (index) => DropdownMenuItem(
            value: index + 0,
            child: Text('${index + 0}  máy lạnh'),
          ),
        ),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }
}
