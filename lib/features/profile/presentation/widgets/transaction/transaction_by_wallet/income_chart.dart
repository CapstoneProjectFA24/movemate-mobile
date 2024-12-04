import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/profile/presentation/screens/wallet/combined_wallet_statistics_screen.dart';
import 'dart:math';
import 'income_providers.dart';

class IncomeChart extends HookConsumerWidget {
  const IncomeChart({super.key});

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
