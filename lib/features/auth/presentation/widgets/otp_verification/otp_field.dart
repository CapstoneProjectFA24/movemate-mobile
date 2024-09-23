import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:movemate/utils/constants/asset_constant.dart';

class OTPField extends HookWidget {
  const OTPField({
    super.key,
    required this.size,
    required this.textController,
    this.isFirst,
    this.isFinal,
  });

  final Size size;
  final TextEditingController textController;
  final bool? isFirst;
  final bool? isFinal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.06,
      width: size.width * 0.11,
      padding: const EdgeInsets.only(
        left: AssetsConstants.defaultPadding - 15.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AssetsConstants.mainColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(
          AssetsConstants.defaultBorder - 5.0,
        ),
      ),
      child: Center(
        child: TextFormField(
          autofocus: isFirst != null,
          controller: textController,
          onChanged: (val) {
            if (val.length == 1) {
              if (isFinal == null) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            }

            if (val.isEmpty) {
              if (isFirst == null) {
                FocusScope.of(context).previousFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            }
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: AssetsConstants.defaultFontSize - 6.0,
            fontWeight: FontWeight.w600,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
