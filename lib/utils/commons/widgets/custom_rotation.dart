import 'package:flutter/material.dart';
import '../../constants/asset_constant.dart';

class CustomRotation extends StatelessWidget {
  const CustomRotation({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            // you can replace this with Image.asset
            AssetsConstants.appLogo,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
          // you can replace
          const SizedBox(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AssetsConstants.primaryDark),
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
