import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'package:movemate/features/payment/presentation/widget/all_payment_method/add_new_card.dart';
import 'package:movemate/features/payment/presentation/widget/all_payment_method/payment_method_items.dart';
import 'package:movemate/features/payment/presentation/widget/all_payment_method/section_title.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class SeeAllPaymentMethodScreen extends HookConsumerWidget {
  const SeeAllPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = useState("ZaloPay");

    // List of payment methods
    final List<PaymentModelsSeeAllPaymentMethodItems> pamentMethodItems = [
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/zaloPay.png',
        methodName: 'Zalopay',
        isLinked: false,
        linkedText: 'Chưa liên kết',
        methodValue: 'ZaloPay',
        selectedMethod: selectedMethod,
        additionalText: 'Nhập ZLPN50 giảm 50% cho bạn mới',
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/viettelpay.png',
        methodName: 'ViettelMoney',
        isLinked: true,
        linkedText: '',
        methodValue: 'ViettelMoney',
        selectedMethod: selectedMethod,
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/MoMo_Logo.png',
        methodName: 'Vi MoMo',
        isLinked: true,
        linkedText: '',
        methodValue: 'MoMo',
        selectedMethod: selectedMethod,
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/Logo_ShopeePay.png',
        methodName: 'ShopeePay',
        isLinked: false,
        linkedText: 'Chưa liên kết',
        methodValue: 'ShopeePay',
        selectedMethod: selectedMethod,
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/wallet_acc.png',
        methodName: 'Tài khoản',
        isLinked: true,
        linkedText: '',
        methodValue: 'Account',
        selectedMethod: selectedMethod,
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/cash_depositor.png',
        methodName: 'Người gửi trả tiền mặt',
        isLinked: true,
        linkedText: '',
        methodValue: 'CashSender',
        selectedMethod: selectedMethod,
      ),
      PaymentModelsSeeAllPaymentMethodItems(
        iconPath: 'assets/images/logo_wallets/cash_sender.png',
        methodName: 'Người nhận trả tiền mặt',
        isLinked: true,
        linkedText: '',
        methodValue: 'CashReceiver',
        selectedMethod: selectedMethod,
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                PaymentMethodSection(
                  title: "Thanh toán không dùng tiền mặt",
                  methods: [
                    // Map all elements except the last two
                    ...pamentMethodItems
                        .sublist(0, pamentMethodItems.length - 2)
                        .map((item) => PaymentMethodItem(
                              paymentModelsitems: item,
                            )),
                    const AddNewCardComponent(
                      iconPath: 'assets/images/logo_wallets/new_Card.png',
                    ),
                    const Divider(height: 32),
                  ],
                ),
                PaymentMethodSection(
                  title: "Thanh toán bằng tiền mặt",
                  methods: [
                    // Map the last two elements of the list
                    ...pamentMethodItems
                        .sublist(pamentMethodItems.length - 2)
                        .map((item) => PaymentMethodItem(
                              paymentModelsitems: item,
                            )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AssetsConstants.primaryDark,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the modal when pressed
                },
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(
                    fontSize: 16,
                    color: AssetsConstants.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: Text(
          'Chọn phương thức thanh toán',
          style: TextStyle(color: AssetsConstants.blackColor),
        ),
      ),
      centerTitle: true,
      backgroundColor: AssetsConstants.whiteColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: IconButton(
          icon: const Icon(
            Icons.close,
            color: AssetsConstants.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
