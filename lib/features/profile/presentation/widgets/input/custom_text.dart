import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String value;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    );
  }
}
