// lib/widgets/address_row.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

Widget buildPriceItem(String description, String price,
    {bool isStrikethrough = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              decoration: isStrikethrough
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 12),
            Text(
              price,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                decoration: isStrikethrough
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(width: 12),
            // IconButton(
            //   icon: const Icon(Icons.more_horiz_outlined, color: Colors.black),
            //   onPressed: () {
            //     // Xử lý sự kiện khi nhấp vào biểu tượng 3 chấm
            //   },
            //   tooltip: 'More options',
            // ),
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
      Text(label, style: const TextStyle(color: AssetsConstants.blackColor)),
      Text(value, style: const TextStyle(color: Colors.black)),
    ],
  );
}
