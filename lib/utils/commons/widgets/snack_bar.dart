import 'package:flutter/material.dart';
import '../../constants/asset_constant.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
  required Icon icon,
  required Color backgroundColor,
  required Color textColor,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        elevation: 0,
        backgroundColor: AssetsConstants.transparentColor,
        content: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(
            horizontal: AssetsConstants.defaultPadding - 9.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                content,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AssetsConstants.defaultFontSize - 14.0,
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
}
