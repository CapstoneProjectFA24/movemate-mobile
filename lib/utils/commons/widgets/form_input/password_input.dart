import 'package:flutter/material.dart';
import '../../../constants/asset_constant.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String hintTextLable;
  final String Function(String val) onValidate;
  final bool autoFocus;
  const PasswordInput({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.hintTextLable,
    required this.onValidate,
    required this.autoFocus,
  });

  @override
  State<PasswordInput> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<PasswordInput> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ValueListenableBuilder(
      valueListenable: widget.textEditingController,
      builder: (context, value, _) => TextFormField(
        autofocus: widget.autoFocus,
        validator: (val) {
          if (val != null && val.isNotEmpty) {
            var error = widget.onValidate(val);
            if (error != '') {
              return error;
            } else {
              return null;
            }
          }

          return 'Mục này Không được bỏ trống';
        },
        obscureText: isObscureText,
        controller: widget.textEditingController,
        style: const TextStyle(
          fontSize: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          label: LabelText(
            content: widget.hintTextLable,
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
          hintText: widget.hintText,
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
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
              right: AssetsConstants.defaultPadding - 2.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.textEditingController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    child: Icon(
                      isObscureText ? Icons.visibility : Icons.visibility_off,
                      color: AssetsConstants.cancelIconColor,
                      size: AssetsConstants.defaultFontSize - 6.0,
                    ),
                  ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                if (widget.textEditingController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      widget.textEditingController.clear();
                      if (!isObscureText) {
                        setState(() {
                          isObscureText = true;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: AssetsConstants.cancelIconColor,
                      size: AssetsConstants.defaultFontSize - 6.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
