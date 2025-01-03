import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:movemate/features/profile/data/models/request/unlock_wallet_request.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/credit_card/card_input_formatter.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';

class CreditCardWidget extends HookConsumerWidget {
  const CreditCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width < 600 && screenSize.width >= 360;

    // Calculate responsive dimensions
    final cardWidth = screenSize.width < 600
        ? screenSize.width * 0.80 // For mobile devices
        : screenSize.width * 0.4; // For tablets and larger
    final cardPadding = screenSize.width * 0.05;

    final wallet = ref.read(walletProvider);
    // final isCardLocked = useState<bool>(true);
    final isCardLocked = useState<bool>(wallet?.isLocked ?? true);
    final cardNumber = useState<String>(wallet?.bankNumber ?? '');
    final cardHolder = useState<String>(wallet?.cardHolderName ?? '');
    final expiryDate = useState<String>(wallet?.expirdAt ?? '');
    final selectedBank = useState<String?>(wallet?.bankName ?? '');

    // New state to persist card holder and expiry date
    final savedCardHolder = useState<String>('');
    final savedExpiryDate = useState<String>('');

    final tempCardNumberController = useTextEditingController();
    final tempCardHolderController = useTextEditingController();
    final tempExpiryDateController = useTextEditingController();

    final unlockWalletRequest = useState<UnlockWalletRequest?>(null);
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
                              maxLength: 20,
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
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Update all states
                        cardNumber.value = tempCardNumberController.text;
                        cardHolder.value = tempCardHolderController.text;
                        expiryDate.value = tempExpiryDateController.text;

                        // Save card holder and expiry date to persistent state
                        savedCardHolder.value = tempCardHolderController.text;
                        savedExpiryDate.value = tempExpiryDateController.text;
                        // Create and update the UnlockWalletRequest instance
                        unlockWalletRequest.value = UnlockWalletRequest(
                          bankNumber: tempCardNumberController.text,
                          bankName: selectedBank.value,
                          cardHolderName: tempCardHolderController.text,
                          expirdAt: tempExpiryDateController.text,
                        );

                        final res = await ref
                            .read(profileControllerProvider.notifier)
                            .unlockWallet(
                                unlockWalletRequest.value
                                    as UnlockWalletRequest,
                                context);
                        if (res?.isLocked == false) {
                          isCardLocked.value = res?.isLocked ?? false;
                        }
                        // isCardLocked.value = res?.isLocked ?? false;

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
        width: cardWidth,
        padding: EdgeInsets.all(cardPadding),
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
                          FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  cardHolder.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
