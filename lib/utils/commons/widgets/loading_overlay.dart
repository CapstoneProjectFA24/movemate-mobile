import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../constants/asset_constant.dart';
import './custom_rotation.dart';

class LoadingOverlay extends HookWidget {
  final Widget child;
  final bool isLoading;
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const Opacity(
            opacity: 0.9,
            child: ModalBarrier(
              dismissible: false,
              color: AssetsConstants.whiteColor,
            ),
          ),
        if (isLoading)
          const Center(
            child: CustomRotation(),
          ),
      ],
    );
  }
}
