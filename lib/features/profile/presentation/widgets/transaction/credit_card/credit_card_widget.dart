import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/credit_card/card_input_formatter.dart';

class CreditCardWidget extends HookConsumerWidget {
  const CreditCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCardLocked = useState<bool>(true);
    final cardNumber = useState<String>('');
    final cardHolder = useState<String>('');
    final expiryDate = useState<String>('');
    final selectedBank = useState<String?>(null);

    // New state to persist card holder and expiry date
    final savedCardHolder = useState<String>('');
    final savedExpiryDate = useState<String>('');

    final tempCardNumberController = useTextEditingController();
    final tempCardHolderController = useTextEditingController();
    final tempExpiryDateController = useTextEditingController();

    // List of banks for dropdown
    final banks = [
      'Vietcombank',
      'Techcombank',
      'BIDV',
      'Agribank',
      'VPBank',
      'MB Bank',
      'ACB',
      'TPBank'
    ];

    Future<void> showCardInputDialog() async {
      final formKey = GlobalKey<FormState>();

      // Reset controllers and selected bank
      tempCardNumberController.text = '';
      tempCardHolderController.text = '';
      tempExpiryDateController.text = '';
      selectedBank.value = null;

      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  'Thêm thông tin thẻ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Bank Selection Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedBank.value,
                            decoration: const InputDecoration(
                              labelText: 'Chọn Ngân hàng',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.black, // Màu text khi đã chọn
                              fontSize: 16,
                            ),
                            items: banks.map((String bank) {
                              return DropdownMenuItem<String>(
                                value: bank,
                                child: Text(
                                  bank,
                                  style: const TextStyle(
                                    color: Colors.black, // Màu text trong menu
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBank.value = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn ngân hàng';
                              }
                              return null;
                            },
                          ),
                          if (selectedBank.value != null) ...[
                            const SizedBox(height: 16),
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
                              maxLength: 19,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                CardNumberInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Số thẻ không được để trống';
                                }
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
                              maxLength: 5,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                ExpiryDateInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ngày hết hạn không được để trống';
                                }
                                final regex =
                                    RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Không đúng định dạng';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Update all states
                        cardNumber.value = tempCardNumberController.text;
                        cardHolder.value = tempCardHolderController.text;
                        expiryDate.value = tempExpiryDateController.text;

                        // Save card holder and expiry date to persistent state
                        savedCardHolder.value = tempCardHolderController.text;
                        savedExpiryDate.value = tempExpiryDateController.text;

                        isCardLocked.value = false;
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: const Text('Xác nhận'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result == null || !result) {
        // User cancelled, do nothing
      }
    }

    // Rest of the widget build method remains the same
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VISA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        selectedBank.value ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
