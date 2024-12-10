import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/transaction_controller/transaction_controller.dart';
import 'package:movemate/features/profile/presentation/screens/wallet/combined_wallet_statistics_screen.dart';
import 'package:movemate/features/promotion/presentation/widgets/voucher_modal/voucher_modal.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/transaction_status_enum.dart';
import 'package:movemate/utils/providers/common_provider.dart';

class IncomeBreakdown extends HookConsumerWidget {
  const IncomeBreakdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);

    final controller = ref.read(transactionControllerProvider.notifier);

    // Sử dụng useFetch để lấy danh sách ServicesPackageTruckEntity
    final fetchResult = useFetch<TransactionEntity>(
      function: (model, context) async {
        // Gọi API và lấy dữ liệu ban đầu
        final servicesList =
            await controller.getTransactionByUserIdWithWallet(model, context);

        // Trả về danh sách ServicesPackageTruckEntity
        return servicesList;
      },
      initialPagingModel: PagingModel(),
      context: context,
    );

    print("object chekc list wallet ${fetchResult.items.toList().toString()}");
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch sử giao dịch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...fetchResult.items.map((item) => _IncomeBreakdownItem(item: item)),
        ],
      ),
    );
  }
}

class _IncomeBreakdownItem extends StatelessWidget {
  final TransactionEntity item;

  const _IncomeBreakdownItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(item.createdAt.toString());
    final cardColor = getCardColorWallet(item.transactionType);
    final amountPrefix = defineAmountPrefix(item.transactionType);
    final amountColor = getAmountColor(item.transactionType);
    // Chuyển đổi trạng thái sang enum
    final transactionStatus =
        TransactionStatus.fromString(item.transactionType);
    // Lấy tên tiếng Việt
    final statusVietnamese =
        transactionStatus?.toVietnamese() ?? 'Không xác định';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '$amountPrefix ${formatPrice(item.amount.toDouble())}',
            style: TextStyle(fontSize: 16, color: amountColor),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              statusVietnamese,
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

//hàm để format ngày
String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}
