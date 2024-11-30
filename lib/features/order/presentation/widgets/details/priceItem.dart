// lib/widgets/address_row.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

Widget buildPriceItem(
  String description,
  String price, {
  bool isStrikethrough = false,
  bool? isBackground,
  int? quantity,
}) {
  Color backgroundColor;
  if (isBackground == true) {
    backgroundColor =
        const Color(0xFFFFEBE9); // #ffebe9 if isBackground is true
  } else if (isBackground == false) {
    backgroundColor =
        const Color(0xFFd1f8d9); // #d1f8d9 if isBackground is false
  } else {
    backgroundColor = Colors.white; // Default to white if isBackground is null
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isStrikethrough ? FontWeight.w400 : FontWeight.w500,
                color: isStrikethrough ? Colors.red : Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          if (quantity != null && quantity > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'x$quantity',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isStrikethrough ? Colors.red : Colors.black,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              price,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isStrikethrough ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildSummary(
  String label,
  String value, {
  FontWeight fontWeight = FontWeight.normal, // Default value for fontWeight
  double textSize = 14.0, // Default value for textSize
  Color textColor = Colors.black, // Default value for textColor
  bool? isBackground,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AssetsConstants.blackColor,
          fontWeight: fontWeight, // Apply custom fontWeight
          fontSize: textSize, // Apply custom textSize
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: textColor, // Apply custom textColor
          fontWeight: fontWeight, // Apply custom fontWeight
          fontSize: textSize, // Apply custom textSize
        ),
      ),
    ],
  );
}
