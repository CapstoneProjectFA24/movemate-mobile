// lib/widgets/address_row.dart

import 'package:flutter/material.dart';

Widget buildAddressRow(IconData icon, String address) {
  return Row(
    children: [
      Icon(icon, size: 20, color: Colors.black),
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
