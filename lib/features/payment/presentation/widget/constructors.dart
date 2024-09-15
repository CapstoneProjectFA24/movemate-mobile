// constructors.dart
// Đây là nơi định nghĩa các constructors dùng chung cho các widget hoặc model.

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// Ví dụ về một constructor dùng chung cho các TextStyle
TextStyle commonTextStyle(
    {double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AssetsConstants.blackColor}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

// Ví dụ về một widget constructor
Widget commonPadding({required Widget child, double padding = 16.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: child,
  );
}
