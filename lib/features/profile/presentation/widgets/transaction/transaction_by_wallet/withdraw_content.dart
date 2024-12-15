import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/data/models/queries/with_draw_queries.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_by_wallet/diaglog_with_draw_success.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/text_input_format_price/text_input_format_price.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/price_helper.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';

// final withdrawMethodList = [
//   WithdrawMethodType.bank,
//   WithdrawMethodType.momo,
// ];

class WithdrawContent extends HookConsumerWidget {
  const WithdrawContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(walletProvider);
    // final selectedMethod = ref.watch(withdrawMethodProvider);
    final paymentController = ref.watch(profileControllerProvider.notifier);
    final amountController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    final isWalletLocked = wallet?.isLocked ?? false;
    final previousValidValue = useState<double?>(0.0);
    final isLoading = useState<bool>(false);

    void handleAmountInput(String value) {
      // Remove non-numeric characters
      String cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      int parsedValue = int.tryParse(cleanedValue) ?? 0;

      // Validate withdrawal amount
      if (parsedValue < 10000) {
        errorMessage.value = "Số tiền rút phải lớn hơn 10,000 đ";
      } else if (parsedValue > wallet!.balance) {
        errorMessage.value = "Số dư không đủ để rút";
      } else if (parsedValue > 10000000) {
        errorMessage.value = "Số tiền không được vượt quá 10 triệu";
        // Restore previous valid value
        parsedValue = previousValidValue.value!.toInt();
        amountController.text =
            NumberFormat("#,###", "vi_VN").format(parsedValue);
        amountController.selection =
            TextSelection.collapsed(offset: amountController.text.length);
      } else {
        errorMessage.value = null;
        // Update previous valid value
        previousValidValue.value = parsedValue.toDouble();
        // Update currency formatting
        amountController.text =
            NumberFormat("#,###", "vi_VN").format(parsedValue);
        amountController.selection =
            TextSelection.collapsed(offset: amountController.text.length);
      }
    }

    Future<void> handleWithdrawButtonPressed() async {
      if (isLoading.value) return;
      try {
        final amountText =
            amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
        final amount = double.tryParse(amountText) ?? 0.0;
        isLoading.value = true;
        // Additional validation
        if (amount < 10000) {
          errorMessage.value = "Số tiền rút phải lớn hơn 10,000 đ";
          return;
        }

        if (amount > wallet!.balance) {
          errorMessage.value = "Số dư không đủ để rút";
          return;
        }

        if (amount > 10000000) {
          errorMessage.value = "Số tiền không được vượt quá 10 triệu";
          return;
        }
        final amountWithdraw = WithDrawQueries(
          amount: amount,
        );

        await paymentController.withDrawWallet(
          context: context,
          request: amountWithdraw,
        );
        print("yêu cầu rút tiền thành công ");

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuccessDialog(
              message: 'Yêu cầu rút tiền thành công',
              onConfirm: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, navigate to another screen or perform other actions
              },
            );
          },
        );
      } catch (e) {
        print("Withdraw failed: $e");
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> handleUnlockWallet() async {
      context.router.popAndPush(const ListTransactionScreenRoute());
    }

    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Wallet Balance
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.account_balance_wallet,
                              color: AssetsConstants.primaryMain),
                          Text(
                            'Số dư Ví: ${PriceHelper.formatPrice(wallet?.balance.toDouble() ?? 0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(right: 180.0),
                      child: Text(
                        'Số tiền cần rút',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Withdraw Amount
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                          top: 2, bottom: 2, right: 10, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                CurrencyTextInputFormatter(),
                              ],
                              onChanged: handleAmountInput,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                              enabled: !isWalletLocked,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('đ', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),

                    // Error Message (if any)
                    if (errorMessage.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage.value!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Wallet locked message
                    if (isWalletLocked)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Ví chưa được mở khóa',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: isWalletLocked
                ? handleUnlockWallet
                : () {
                    handleWithdrawButtonPressed();
                  },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AssetsConstants.primaryMain,
                    AssetsConstants.primaryLight,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  isWalletLocked ? 'Mở khóa thẻ' : 'RÚT TIỀN',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
