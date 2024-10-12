// lib/widgets/address_row.dart

import 'package:flutter/material.dart';

Widget buildAddressRow(IconData icon, String address) {
  return Row(
    children: [
      Icon(icon),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          address,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}
