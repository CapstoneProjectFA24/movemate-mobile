import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class RoundTripCheckbox extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool?> onChanged;

  const RoundTripCheckbox({
    super.key,
    required this.isRoundTrip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AssetsConstants.greyColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          FadeInLeft(
            child: Checkbox(
              checkColor: AssetsConstants.primaryLight,
              activeColor: AssetsConstants.primaryDark,
              value: isRoundTrip,
              onChanged: onChanged,
            ),
          ),
          FadeInLeft(
              child: const LabelText(
            content: 'Vận chuyển 2 chiều',
            size: Checkbox.width + 4,
            fontFamily: 'popins',
            fontWeight: FontWeight.w400,
          )),
          const Spacer(),
          FadeInRight(child: const Text('+70%')),
        ],
      ),
    );
  }
}
