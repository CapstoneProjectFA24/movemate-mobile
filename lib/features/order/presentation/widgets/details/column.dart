// lib/widgets/detail_column.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

Widget buildDetailColumn(IconData icon, String text) {
  return Row(
    children: [
      const SizedBox(width: 44),
      Icon(icon, size: 16, color: Colors.black),
      const SizedBox(height: 5),
      const SizedBox(width: 5),
      LabelText(
        content: text,
        size: 14,
        fontWeight: FontWeight.w400,
      ),
    ],
  );
}
