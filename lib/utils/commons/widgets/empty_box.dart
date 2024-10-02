import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/asset_constant.dart';
import 'widgets_common_export.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.only(
        top: AssetsConstants.defaultMargin,
      ),
      width: size.width * 0.9,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        color: AssetsConstants.primaryLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.boxArchive,
            size: AssetsConstants.defaultFontSize - 6.0,
            color: AssetsConstants.primaryDarker,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          LabelText(
            content: title,
            size: AssetsConstants.defaultFontSize - 6.0,
            color: AssetsConstants.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
