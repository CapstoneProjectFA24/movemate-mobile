import 'package:flutter/material.dart';
import '../../../constants/asset_constant.dart';

class LabelText extends StatelessWidget {
  final String content;
  final double size;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final int? maxLine;
  const LabelText({
    super.key,
    required this.content,
    required this.size,
    this.fontWeight = FontWeight.w200,
    this.color = AssetsConstants.blackColor,
    this.fontFamily = 'Open Sans',
    this.textDecoration,
    this.textAlign = TextAlign.start,
    this.maxLine = AssetsConstants.defaultMaxline,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        decoration: textDecoration,
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }
}
