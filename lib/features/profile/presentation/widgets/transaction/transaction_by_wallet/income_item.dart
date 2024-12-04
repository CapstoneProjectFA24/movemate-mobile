import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  IncomeItem copyWith({
    String? title,
    double? amount,
    double? percentage,
    Color? color,
  }) {
    return IncomeItem(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
    );
  }
}

class IncomeNotifier extends StateNotifier<List<IncomeItem>> {
  IncomeNotifier()
      : super([
          const IncomeItem(
            title: 'RECEIVE',
            amount: 0.0,
            percentage: 0.0,
            color: Color(0xFFD3D3F3),
          ),
          const IncomeItem(
            title: 'RECHARGE',
            amount: 0.0,
            percentage: 0.0,
            color: Color(0xFFFFB6C1),
          ),
        ]);

  void updatePercentages(List<dynamic> transactions) {
    final percentages = calculateTransactionTypePercentages(transactions);
    state = [
      for (final item in state)
        item.copyWith(
          percentage: percentages[item.title] ?? 0.0,
          amount: transactions
              .where((t) => t['transactionType'] == item.title)
              .fold(0.0, (sum, t) => sum! + t['amount']),
        ),
    ];
  }
}

Map<String, double> calculateTransactionTypePercentages(
    List<dynamic> transactions) {
  final totalTransactions = transactions.length;
  final transactionTypeCounts = <String, int>{};

  for (final transaction in transactions) {
    final transactionType = transaction['transactionType'];
    transactionTypeCounts[transactionType] =
        (transactionTypeCounts[transactionType] ?? 0) + 1;
  }

  final transactionTypePercentages = <String, double>{};
  for (final entry in transactionTypeCounts.entries) {
    final percentage = (entry.value / totalTransactions) * 100;
    transactionTypePercentages[entry.key] = percentage;
  }

  return transactionTypePercentages;
}
