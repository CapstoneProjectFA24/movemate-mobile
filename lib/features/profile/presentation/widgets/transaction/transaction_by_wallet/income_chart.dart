import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/confirm_last_payment/confirm_last_payment.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/transaction_controller/transaction_controller.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_by_wallet/income_item.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'dart:math';

final incomeProvider =
    StateNotifierProvider<IncomeNotifier, List<IncomeItem>>((ref) {
  return IncomeNotifier();
});

class IncomeChart extends HookConsumerWidget {
  const IncomeChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeItems = ref.watch(incomeProvider);

    final state = ref.watch(transactionControllerProvider);

    final controller = ref.read(transactionControllerProvider.notifier);

    // Sử dụng useFetch để lấy danh sách ServicesPackageTruckEntity
    final fetchResult = useFetch<TransactionEntity>(
      function: (model, context) async {
        // Gọi API và lấy dữ liệu ban đầu
        final servicesList =
            await controller.getTransactionByUserIdWithWallet(model, context);
        // Cập nhật tỉ lệ phần trăm cho IncomeItem

        // Trả về danh sách ServicesPackageTruckEntity
        return servicesList;
      },
      initialPagingModel: PagingModel(),
      context: context,
    );

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
                      'Tổng tiền nhận',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      formatPrice(totalIncome.toInt()),
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
