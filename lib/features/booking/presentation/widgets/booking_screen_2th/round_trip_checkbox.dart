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
              content: 'Di chuyển lần 2',
              size: 16,
              fontFamily: 'popins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          FadeInRight(
            child: const Text(
              '+70%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
