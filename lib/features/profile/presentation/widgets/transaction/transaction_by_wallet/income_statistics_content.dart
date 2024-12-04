import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'income_chart.dart';
import 'income_breakdown.dart';

class IncomeStatisticsContent extends HookConsumerWidget {
  const IncomeStatisticsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          IncomeChart(),
          SizedBox(height: 20),
          IncomeBreakdown(),
        ],
      ),
    );
  }
}