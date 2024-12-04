import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/transaction_controller/transaction_controller.dart';
import 'package:movemate/features/profile/presentation/screens/wallet/combined_wallet_statistics_screen.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/providers/common_provider.dart';
import 'income_providers.dart';

class IncomeBreakdown extends HookConsumerWidget {
  const IncomeBreakdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeItems = ref.watch(incomeProvider);

    final state = ref.watch(transactionControllerProvider);
    final user = ref.watch(authProvider);
    final controller = ref.read(transactionControllerProvider.notifier);

    // Sử dụng useFetch để lấy danh sách ServicesPackageTruckEntity
    final fetchResult = useFetch<TransactionEntity>(
      function: (model, context) async {
        // Gọi API và lấy dữ liệu ban đầu
        final servicesList =
            await controller.getTransactionByUserId(model, context);

        // Trả về danh sách ServicesPackageTruckEntity
        return servicesList;
      },
      initialPagingModel: PagingModel(
        userId: user?.id,
        isWallet: true,
      ),
      context: context,
    );

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Income Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...incomeItems.map((item) => _IncomeBreakdownItem(item: item)),
        ],
      ),
    );
  }
}

class _IncomeBreakdownItem extends StatelessWidget {
  final IncomeItem item;

  const _IncomeBreakdownItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '\$${item.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${item.percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
