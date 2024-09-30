import 'package:flutter/material.dart';
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
        controller: textController,
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
        style: const TextStyle(
          color: AssetsConstants.blackColor,
          fontSize: AssetsConstants.defaultFontSize - 10.0,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: hintTextLable,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelStyle: const TextStyle(
            color: AssetsConstants.blackColor,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AssetsConstants.mainColor,
              width: 2.0,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AssetsConstants.red4,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AssetsConstants.red4,
              width: 2.0,
            ),
          ),
          errorStyle: const TextStyle(
            color: AssetsConstants.red4,
          ),
          contentPadding: const EdgeInsets.all(12),
          suffixIcon: textController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    textController.clear();
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: AssetsConstants.cancelIconColor,
                    size: AssetsConstants.defaultFontSize - 6.0,
                  ),
                )
              : null,
        ),
        onChanged: (value) {
          (context as Element).markNeedsBuild();
        },
      ),
    );
  }
}
