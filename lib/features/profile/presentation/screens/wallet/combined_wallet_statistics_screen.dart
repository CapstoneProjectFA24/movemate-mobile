// combined_wallet_statistics.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_payment_screen.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_by_wallet/income_breakdown.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_by_wallet/income_statistics_content.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_by_wallet/wallet_content.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'dart:math';

import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/text_input_format_price/text_input_format_price.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';
import 'package:movemate/utils/enums/price_helper.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';


@RoutePage()
// Main Combined Widget
class CombinedWalletStatisticsScreen extends HookConsumerWidget {
  const CombinedWalletStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(0);

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
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: Column(
          children: [
            _StatisticsTabs(
              selectedTab: selectedTab,
              onTabChanged: (index) => selectedTab.value = index,
            ),
            Expanded(
              child: selectedTab.value == 0
                  ? const WalletContent()
                  : const IncomeStatisticsContent(),
            ),
          ],
        ),
      ),
    );
  }
}

// Tabs Widget
class _StatisticsTabs extends StatelessWidget {
  final ValueNotifier<int> selectedTab;
  final Function(int) onTabChanged;

  const _StatisticsTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            text: 'Nạp tiền',
            isSelected: selectedTab.value == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            text: 'Thống kê',
            isSelected: selectedTab.value == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: const Color(0xFF8A2BE2),
            ),
        ],
      ),
    );
  }
}
