import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'income_models.dart';

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
