import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
final refreshWallet = StateProvider.autoDispose<bool>(
  (ref) => true,
);
class BalanceIndicator extends HookConsumerWidget {
  const BalanceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    final state = ref.watch(profileControllerProvider);
    final useFetchResultWallet = useFetchObject<WalletEntity>(
      function: (context) async {
        print('check screen');
        return ref.read(profileControllerProvider.notifier).getWallet(context);
      },
      context: context,
    );
    final walletUser = useFetchResultWallet.isFetchingData
        ? 0
        : useFetchResultWallet.data?.balance ?? 0;
        // final result = useFetchResultWallet.refresh;

    print(" số dư : $walletUser");

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: FadeInLeft(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          decoration: BoxDecoration(
            color: AssetsConstants.primaryLighter,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: LabelText(
              content: 'Số dư ${formatPrice(walletUser.toInt())}',
              size: 14,
              fontWeight: FontWeight.w600,
              color: AssetsConstants.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
