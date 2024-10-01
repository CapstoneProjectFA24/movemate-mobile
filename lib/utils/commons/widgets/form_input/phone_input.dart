import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import '../../../constants/asset_constant.dart';

class PhoneInput extends HookConsumerWidget {
  const PhoneInput({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final errorText = useState<String?>(null);
    final isFocused = useState(false);

    String? getErrorText(String value) {
      String error = onValidate(value);
      return error.isNotEmpty ? error : null;
    }

    useEffect(() {
      void validateInput() {
        if (!isFocused.value) {
          errorText.value = getErrorText(textController.text);
        }
      }

      textController.addListener(validateInput);
      return () => textController.removeListener(validateInput);
    }, [textController]);

    return ValueListenableBuilder(
      valueListenable: textController,
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
            controller: textController,
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
              suffixIcon: value.text.isNotEmpty
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }
}
