import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  // Khai báo và khởi tạo formatter cho số tiền
  final NumberFormat _formatter = NumberFormat("#,###", "vi_VN");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If the string is empty, return it as is
    if (newText.isEmpty) {
      return TextEditingValue();
    }

    // Format the number
    String formatted = _formatter.format(int.parse(newText));

    // Return the new value with the formatted text
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
