// lib/widgets/detail_column.dart

import 'package:flutter/material.dart';

Widget buildDetailColumn(IconData icon, String text) {
  return Column(
    children: [
      Icon(icon, size: 24),
      const SizedBox(height: 5),
      Text(text),
    ],
  );
}
