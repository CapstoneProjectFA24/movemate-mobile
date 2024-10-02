import 'package:flutter/material.dart';
import '../../constants/asset_constant.dart';

class CustomCircular extends StatelessWidget {
  const CustomCircular({super.key});

  @override
  Widget build(BuildContext context) {
    // init
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          bottom: AssetsConstants.defaultMargin,
        ),
        width: size.width * 0.055,
        height: size.height * 0.028,
        child: const CircularProgressIndicator(
          color: AssetsConstants.mainColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
