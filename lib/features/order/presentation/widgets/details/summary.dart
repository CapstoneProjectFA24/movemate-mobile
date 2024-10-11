// lib/widgets/address_row.dart

import 'package:flutter/material.dart';

Widget buildSummary(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(color: Colors.green)),
    ],
  );
}
