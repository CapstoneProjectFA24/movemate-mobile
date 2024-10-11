// lib/widgets/booking_code.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildBookingCode(String label, String code) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF1F1F1),
      borderRadius: BorderRadius.circular(5),
    ),
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold), // Tiêu đề
            ),
            Text(code), // Mã đặt chỗ
          ],
        ),
        const Icon(FontAwesomeIcons.copy, color: Color(0xFF007bff)),
      ],
    ),
  );
}
