// lib/widgets/policies.dart

import 'package:flutter/material.dart';

Widget buildPolicies(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: const Color(0xFF28a745)),
      const SizedBox(width: 10),
      Expanded(child: Text(text)),
    ],
  );
}
