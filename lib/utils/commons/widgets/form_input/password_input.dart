import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import '../../../constants/asset_constant.dart';

class PasswordInput extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscureText = useState(true);
    final errorText = useState<String?>(null);
    final isFocused = useState(false);

    String? getErrorText(String value) {
      String error = onValidate(value);
      return error.isNotEmpty ? error : null;
    }

    useEffect(() {
      void validateInput() {
        if (!isFocused.value) {
          errorText.value = getErrorText(textEditingController.text);
        }
      }

      textEditingController.addListener(validateInput);

      return () => textEditingController.removeListener(validateInput);
    }, [textEditingController]);

    return ValueListenableBuilder(
      valueListenable: textEditingController,
      builder: (context, value, _) {
        return Focus(
          onFocusChange: (hasFocus) {
            isFocused.value = hasFocus;
            if (!hasFocus) {
              errorText.value = getErrorText(value.text);
            } else {
              errorText.value = null;
            }
          },
          child: TextFormField(
            autofocus: autoFocus,
            controller: textEditingController,
            obscureText: isObscureText.value,
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
              errorText: errorText.value,
              errorStyle: const TextStyle(
                color: AssetsConstants.red4,
                fontWeight: FontWeight.w500,
              ),
              errorMaxLines: 2,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isObscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AssetsConstants.cancelIconColor,
                      size: AssetsConstants.defaultFontSize - 6.0,
                    ),
                    onPressed: () {
                      isObscureText.value = !isObscureText.value;
                    },
                  ),
                  if (value.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        textEditingController.clear();
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: AssetsConstants.cancelIconColor,
                        size: AssetsConstants.defaultFontSize - 6.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
