import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/payment/presentation/screens/deposite_payment/payment_screen.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/snack_bar.dart';
import 'package:movemate/utils/commons/widgets/text_input_format_price/text_input_format_price.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';
import 'package:movemate/utils/enums/price_helper.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';

final paymentList = [
  PaymentMethodType.momo,
  PaymentMethodType.vnpay,
  PaymentMethodType.payos,
];

@RoutePage()
class WalletScreen extends HookConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(walletProvider);
    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentController = ref.watch(paymentControllerProvider.notifier);
    final amountController = useTextEditingController(); // TextController

    // Define the maximum and minimum values
    const int minValue = -2147483648;
    const int maxValue = 2147483647;
    print("chekc wallet ${wallet?.balance}");
    // Method to handle user input and ensure it's within the acceptable range

    // Use the useState hook for error message
    final errorMessage = useState<String?>(null);

    // Method to handle user input and ensure it's within the acceptable range
    void handleAmountInput(String value) {
      String cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      int parsedValue = int.tryParse(cleanedValue) ?? 0;

      // Validate if the value is less than 10,000
      if (parsedValue < 10000) {
        errorMessage.value = "Giá phải lớn hơn 10,000 đ";
      } else {
        errorMessage.value = null; // Clear the error if value is valid
      }

      amountController.text =
          NumberFormat("#,###", "vi_VN").format(parsedValue);
      amountController.selection =
          TextSelection.collapsed(offset: amountController.text.length);
    }

    Future<void> handlePaymentButtonPressed() async {
      try {
        final amountText =
            amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
        final amount = double.tryParse(amountText) ?? 0.0;

        // Validate amount before proceeding
        if (amount < 10000) {
          errorMessage.value = "Giá phải lớn hơn 10,000 đ";
          return;
        }

        await paymentController.createPaymentDeposit(
          context: context,
          selectedMethod: selectedMethod.type,
          amount: amount,
        );
      } catch (e) {
        print("Payment failed: $e");
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
        centerTitle: true,
        title: "Ví của tôi",
        iconSecond: Icons.home_outlined,
        onCallBackFirst: () {
          context.router.back();
        },
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            // Pop back to the TabViewScreen
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          }
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
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
                          'Số dư Ví: ${PriceHelper.formatPrice(wallet?.balance.toInt() ?? 0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(right: 180.0),
                    child: Text(
                      'Số tiền cần nạp',
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true), // Allow decimal input
                            inputFormatters: [
                              CurrencyTextInputFormatter(),
                            ],
                            onChanged:
                                handleAmountInput, // Call this method to format and limit the input
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                            ),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 200.0),
            child: Text(
              'Nạp với ví ${selectedMethod.type}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          // Payment Methods
          // ...paymentMethods.map((method) => _buildPaymentMethod(
          //       method['name'],
          //       method['imageUrl'],
          //       selectedPaymentMethod.value,
          //       (selected) {
          //         selectedPaymentMethod.value = selected;
          //       },
          //     )),

          Column(
            children: paymentList.map((method) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Image.network(
                      method.imageUrl,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      method.displayName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Radio<PaymentMethodType>(
                      value: method,
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(paymentMethodProvider.notifier).state =
                              value;
                        }
                      },
                      activeColor: const Color(0xFFFF7F00),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () {
              handlePaymentButtonPressed();
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
              child: const Center(
                child: Text(
                  'XÁC NHẬN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String label, String imageUrl,
      String? selectedMethod, Function(String) onSelect) {
    return Container(
      margin: const EdgeInsets.only(
          right: 26, left: 26, bottom: 5), // Add spacing between options
      decoration: BoxDecoration(
        color: Colors.white, // White background for container
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(imageUrl, width: 30, height: 30),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Radio<String>(
            value: label,
            groupValue: selectedMethod,
            onChanged: (value) {
              if (value != null) {
                onSelect(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
