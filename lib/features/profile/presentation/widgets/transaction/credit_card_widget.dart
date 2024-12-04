import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

class CreditCardWidget extends HookWidget {
  const CreditCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // State hooks for card lock status and card information
    final isCardLocked = useState<bool>(true);
    final cardNumber = useState<String>('');
    final cardHolder = useState<String>('');
    final expiryDate = useState<String>('');

    // Controllers for the input fields in the modal
    final tempCardNumberController = useTextEditingController();
    final tempCardHolderController = useTextEditingController();
    final tempExpiryDateController = useTextEditingController();

    // Function to show the modal dialog for entering card details
    Future<void> showCardInputDialog() async {
      final formKey = GlobalKey<FormState>();

      // Reset temporary controllers
      tempCardNumberController.text = '';
      tempCardHolderController.text = '';
      tempExpiryDateController.text = '';

      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // User must tap a button
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white, // Improved background color
            title: const Text(
              'Thêm thông tin thẻ',
              style: TextStyle(
                color: Colors.black, // Improved text color
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Card Number Field
                    TextFormField(
                      controller: tempCardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Số Thẻ',
                        hintText: '1234 5678 9876 5432',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength:
                          19, // For formatting like '1234 5678 9876 5432'
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Số thẻ không được để trống';
                        }
                        // Remove spaces for validation
                        String digitsOnly = value.replaceAll(' ', '');
                        if (digitsOnly.length != 16) {
                          return 'Số thẻ phải là 16 số';
                        }
                        if (!RegExp(r'^\d{16}$').hasMatch(digitsOnly)) {
                          return 'Chỉ được nhập số';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Card Holder Field
                    TextFormField(
                      controller: tempCardHolderController,
                      decoration: const InputDecoration(
                        labelText: 'Tên chủ thẻ',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tên không được để trống';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Expiry Date Field
                    TextFormField(
                      controller: tempExpiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày hết hạn',
                        hintText: 'MM/YY',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5, // For format 'MM/YY'
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        ExpiryDateInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ngày hết hạn không được để trống';
                        }
                        final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
                        if (!regex.hasMatch(value)) {
                          return 'Không đúng định dạng';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User cancelled
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: Colors.orange), // Button text color
                ),
              ),
              // Confirm Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button background color
                  iconColor: Colors.white, // Button text color
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Update state with entered information
                    cardNumber.value = tempCardNumberController.text;
                    cardHolder.value = tempCardHolderController.text;
                    expiryDate.value = tempExpiryDateController.text;
                    isCardLocked.value = false; // Unlock the card
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('Xác nhận',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );

      // Optionally handle the result if needed
      if (result == null || !result) {
        // User cancelled, do nothing
      }
    }

    return GestureDetector(
      onTap: () {
        if (isCardLocked.value) {
          showCardInputDialog();
        }
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isCardLocked.value
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade400, Colors.grey.shade600],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.yellow.shade800, Colors.orange.shade700],
                ),
        ),
        child: isCardLocked.value
            ? const Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 40,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VISA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cardNumber.value,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Card Holder Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chủ thẻ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            cardHolder.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // Expiry Date Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Ngày hết hạn',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            expiryDate.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

/// Input Formatter for Expiry Date
class ExpiryDateInputFormatter extends TextInputFormatter {
  // This formatter inserts a '/' after the first two digits
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll('/', '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Input Formatter for Card Number (adds spaces every 4 digits)
class CardNumberInputFormatter extends TextInputFormatter {
  // This formatter inserts a space after every four digits
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(' ', '');
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    String spaced = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      spaced += digitsOnly[i];
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
        spaced += ' ';
      }
    }

    return TextEditingValue(
      text: spaced,
      selection: TextSelection.collapsed(offset: spaced.length),
    );
  }
}
