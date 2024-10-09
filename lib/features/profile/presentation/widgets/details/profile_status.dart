import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final VoidCallback onEditPressed;
  final List<Widget> children;

  const Section(
      {super.key,
      required this.title,
      required this.onEditPressed,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onEditPressed,
              child: const Text(
                'Chỉnh sửa',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}