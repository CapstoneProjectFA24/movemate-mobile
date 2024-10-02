import 'package:flutter/material.dart';
import '../../constants/asset_constant.dart';
import 'widgets_common_export.dart';

class NoMoreContent extends StatelessWidget {
  const NoMoreContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
        child: LabelText(
          content: 'Không còn dữ liệu',
          size: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700]!,
        ),
      ),
    );
  }
}
