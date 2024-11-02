// lib/widgets/address_row.dart

import 'package:flutter/material.dart';

Widget buildPriceItem(String description, String price) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 12),
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.more_horiz_outlined, color: Colors.black),
              onPressed: () {
                // Xử lý sự kiện khi nhấp vào biểu tượng 3 chấm
              },
              tooltip: 'More options',
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildSummary(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.grey.shade800)),
      Text(value, style: const TextStyle(color: Colors.black)),
    ],
  );
}
