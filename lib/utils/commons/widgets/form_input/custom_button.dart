import 'package:flutter/material.dart';
import '../../../constants/asset_constant.dart';
import 'label_text.dart';

class CustomButton extends StatelessWidget {
  final bool isOutline;
  final String content;
  final bool isActive;
  final VoidCallback onCallback;
  final double width;
  final double height;
  final double size;
  final Color backgroundColor;
  final Color contentColor;
  const CustomButton({
    super.key,
    this.isOutline = false,
    required this.content,
    required this.onCallback,
    required this.isActive,
    required this.width,
    required this.height,
    this.size = AssetsConstants.defaultFontSize - 5.0,
    this.backgroundColor = AssetsConstants.mainColor,
    this.contentColor = AssetsConstants.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return InkWell(
        onTap: isActive == true ? onCallback : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AssetsConstants.defaultPadding - 15.0,
          ),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: contentColor),
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            child: LabelText(
              content: content.toUpperCase(),
              size: size,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: isActive == true ? onCallback : null,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: LabelText(
              content: content.toUpperCase(),
              size: size,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ),
      );
    }
  }
}
