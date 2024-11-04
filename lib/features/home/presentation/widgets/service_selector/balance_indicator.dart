import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class BalanceIndicator extends StatelessWidget {
  const BalanceIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          color: AssetsConstants.primaryLighter,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: LabelText(
            content: 'Số dư 0 đ',
            size: 14,
            fontWeight: FontWeight.w600,
            color: AssetsConstants.whiteColor,
          ),
        ),
      ),
    );
  }
}
