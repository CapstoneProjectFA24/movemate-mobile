import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ConfirmationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmationButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: ButtonCustom(
        buttonText: 'Xác nhận',
        buttonColor: AssetsConstants.primaryMain,
        isButtonEnabled: true,
        onButtonPressed: onPressed,
      ),
    );
  }
}
