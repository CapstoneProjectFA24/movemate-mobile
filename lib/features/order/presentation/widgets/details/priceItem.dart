// lib/widgets/address_row.dart

import 'package:flutter/material.dart';

Widget buildPriceItem(String description, String price) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // Sử dụng Expanded để cho phép text chiếm không gian còn lại
          child: Text(
            description,
            maxLines: 2, // Giới hạn số dòng là 2
            overflow: TextOverflow
                .ellipsis, // Hiển thị dấu "..." nếu vượt quá 5 ký tự
            style: const TextStyle(
                fontSize: 14), // Bạn có thể tùy chỉnh kích thước chữ
          ),
        ),
        Row(
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8), // Thêm khoảng cách giữa price và icon
            const Icon(Icons.sync_alt, color: Colors.black),
          ],
        ),
      ],
    ),
  );
}
