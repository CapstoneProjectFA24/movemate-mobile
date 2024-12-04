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

// Models
class IncomeItem {
  final String title;
  final double amount;
  final double percentage;
  final Color color;

  const IncomeItem({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// Providers
final incomeProvider =
    StateNotifierProvider<IncomeNotifier, List<IncomeItem>>((ref) {
  return IncomeNotifier();
});

class IncomeNotifier extends StateNotifier<List<IncomeItem>> {
  IncomeNotifier()
      : super([
          const IncomeItem(
            title: 'Monthly Salary',
            amount: 10086.50,
            percentage: 50,
            color: Color(0xFFD3D3F3),
          ),
          const IncomeItem(
            title: 'Passive Income',
            amount: 3631.14,
            percentage: 18,
            color: Color(0xFFFFB6C1),
          ),
          const IncomeItem(
            title: 'Freelance',
            amount: 3429.41,
            percentage: 17,
            color: Color(0xFF9370DB),
          ),
          const IncomeItem(
            title: 'Side Business',
            amount: 3025.95,
            percentage: 15,
            color: Color(0xFF4B0082),
          ),
        ]);
}

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

class _IncomeStatisticsContent extends HookConsumerWidget {
  const _IncomeStatisticsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _IncomeChart(),
          SizedBox(height: 20),
          IncomeBreakdown(),
        ],
      ),
    );
  }
}

class _IncomeChart extends HookConsumerWidget {
  const _IncomeChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeItems = ref.watch(incomeProvider);
    final totalIncome = incomeItems.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _IncomePieChartPainter(incomeItems),
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TOTAL INCOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '\$${totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomePieChartPainter extends CustomPainter {
  final List<IncomeItem> items;

  _IncomePieChartPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -pi / 2;

    for (var item in items) {
      final paint = Paint()..color = item.color;
      final sweepAngle = 2 * pi * (item.percentage / 100);
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class _IncomeBreakdown extends HookConsumerWidget {
//   const _IncomeBreakdown();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final incomeItems = ref.watch(incomeProvider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Income Breakdown',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         ...incomeItems.map((item) => _IncomeBreakdownItem(item: item)),
//       ],
//     );
//   }
// }

// class _IncomeBreakdownItem extends StatelessWidget {
//   final IncomeItem item;

//   const _IncomeBreakdownItem({
//     required this.item,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             item.title,
//             style: const TextStyle(fontSize: 16),
//           ),
//           Text(
//             '\$${item.amount.toStringAsFixed(2)}',
//             style: const TextStyle(fontSize: 16),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 5,
//             ),
//             decoration: BoxDecoration(
//               color: item.color,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Text(
//               '${item.percentage.toStringAsFixed(0)}%',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
