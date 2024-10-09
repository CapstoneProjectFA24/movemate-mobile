import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
// import 'package:movemate/features/profile/presentation/widgets/custom_app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class WalletScreen extends HookConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> paymentMethods = [
      {
        'name': 'Momo',
        'imageUrl':
            'https://storage.googleapis.com/a1aa/image/2zK0Cfjm5E2EPKLSMJhrSdYCobkA027b7jNfpWhMFwObN1kTA.jpg',
      },
      {
        'name': 'VNpay',
        'imageUrl':
            'https://storage.googleapis.com/a1aa/image/AD4K9t4lzlaiFNVhKEdcKfaOPqXP3jjXtvax7ZthviwumayJA.jpg',
      },
      {
        'name': 'Payos',
        'imageUrl':
            'https://storage.googleapis.com/a1aa/image/KeAcMxfo5OiMpUFeo8OcEDzftpe8kirzeNftegdd1MOweaqJnA.jpg',
      },
    ];

    // Use useState to store the selected payment method
    final selectedPaymentMethod = useState<String?>(null);

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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.account_balance_wallet,
                            color: AssetsConstants.primaryMain),
                        Text(
                          'Số dư Ví: 1.000.000 đ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(right: 200.0),
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
                    padding:
                        const EdgeInsets.only(top: 2, bottom: 2, right: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('đ', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(right: 200.0),
            child: Text(
              'CHI TIẾT GIAO DỊCH',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          // Payment Methods
          ...paymentMethods.map((method) => _buildPaymentMethod(
                method['name'],
                method['imageUrl'],
                selectedPaymentMethod.value,
                (selected) {
                  selectedPaymentMethod.value = selected;
                },
              )),
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
              // Handle confirmation logic
              if (selectedPaymentMethod.value != null) {
                // Handle when a payment method has been selected
              }
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
