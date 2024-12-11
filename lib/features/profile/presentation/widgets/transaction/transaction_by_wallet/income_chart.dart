import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/confirm_last_payment/confirm_last_payment.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/transaction_controller/transaction_controller.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'dart:math';

import 'package:movemate/utils/enums/transaction_status_enum.dart';

class IncomeChart extends HookConsumerWidget {
  const IncomeChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);

    final controller = ref.read(transactionControllerProvider.notifier);

    // Sử dụng useFetch để lấy danh sách transactions
    final fetchResult = useFetch<TransactionEntity>(
      function: (model, context) async {
        // Gọi API và lấy dữ liệu ban đầu
        final servicesList =
            await controller.getTransactionByUserIdWithWallet(model, context);
        // Cập nhật tỉ lệ phần trăm cho IncomeItem

        // Trả về danh sách transactions
        return servicesList;
      },
      initialPagingModel: PagingModel(),
      context: context,
    );
    Map<String, double> transactionTypePercentages = {};
    calculateTransactionTypePercentages(
        fetchResult.items, transactionTypePercentages);

    final totalIncome = fetchResult.items
        .where((e) =>
            e.transactionType == 'RECEIVE' || e.transactionType == 'RECHARGE')
        .fold(0.0, (sum, item) => sum + item.amount);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(200, 200),
              painter: _IncomePieChartPainter(
                  fetchResult.items, transactionTypePercentages),
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
                      'Tổng tiền nhận',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      formatPrice(totalIncome.toDouble()),
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
      ),
    );
  }
}

class _IncomePieChartPainter extends CustomPainter {
  final List<TransactionEntity> items;
  final Map<String, double> transactionTypePercentages;

  _IncomePieChartPainter(this.items, this.transactionTypePercentages);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -pi / 2;

    // Lấy danh sách các transactionType duy nhất
    List<String> uniqueTransactionTypes =
        items.map((item) => item.transactionType).toSet().toList();

    // Vẽ arc cho từng transactionType
    for (String type in uniqueTransactionTypes) {
      final paint = Paint()..color = getCardColorWallet(type);
      double percentage = transactionTypePercentages[type] ?? 0.0;
      final sweepAngle = 2 * pi * (percentage / 100);
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void calculateTransactionTypePercentages(
  List<TransactionEntity> transactions,
  Map<String, double> transactionTypePercentages,
) {
  int totalTransactions = transactions.length;
  Map<String, int> transactionTypeCounts = {};

  for (var transaction in transactions) {
    String type = transaction.transactionType;
    transactionTypeCounts[type] = (transactionTypeCounts[type] ?? 0) + 1;
  }

  transactionTypeCounts.forEach((type, count) {
    double percentage = (count / totalTransactions) * 100;
    transactionTypePercentages[type] = percentage;
  });
}
