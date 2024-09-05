import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import '../../../constants/asset_constant.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.textController,
    required this.hintText,
    required this.hintTextLable,
    required this.onValidate,
    required this.autoFocus,
  });

  final TextEditingController textController;
  final String Function(String val) onValidate;
  final String hintText;
  final String hintTextLable;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: textController,
      builder: (context, value, _) => TextFormField(
        autofocus: autoFocus,
        validator: (val) {
          if (val != null && val.isNotEmpty) {
            var error = onValidate(val);
            if (error != '') {
              return error;
            } else {
              return null;
            }
          }

          return 'Mục này không được bỏ trống';
        },
        controller: textController,
        style: const TextStyle(
          fontSize: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          label: LabelText(
            content: hintTextLable,
            size: AssetsConstants.defaultFontSize - 12.0,
            fontWeight: FontWeight.w700,
            color: AssetsConstants.subtitleColor,
            textDecoration: TextDecoration.none,
          ),
          errorMaxLines: 2,
          errorStyle: const TextStyle(
            fontSize: AssetsConstants.defaultFontSize - 15.0,
          ),
          contentPadding: const EdgeInsets.all(
            AssetsConstants.defaultPadding - 5.0,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: AssetsConstants.defaultFontSize - 12.0,
            color: AssetsConstants.textBlur,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AssetsConstants.mainColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AssetsConstants.borderColor,
              width: 2,
            ),
          ),
          suffixIcon: textController.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: AssetsConstants.defaultPadding - 16.0,
                  ),
                  child: IconButton(
                    onPressed: () {
                      textController.clear();
                    },
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: AssetsConstants.cancelIconColor,
                      size: AssetsConstants.defaultFontSize - 6.0,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
