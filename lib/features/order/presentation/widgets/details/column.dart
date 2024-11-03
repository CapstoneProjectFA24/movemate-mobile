// lib/widgets/detail_column.dart

import 'package:flutter/material.dart';

Widget buildDetailColumn(IconData icon, String text) {
  return Row(
    children: [
      const SizedBox(width: 44),
      Icon(icon, size: 16, color: Colors.black),
      const SizedBox(height: 5),
      const SizedBox(width: 5),
      Text(text),
    ],
  );
}
