// voucher_in_order.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/list_vouchers_response_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

class VoucherInOrder extends HookConsumerWidget {
  final ListVouchersResponseEntity? voucher;

  const VoucherInOrder({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promotionControllerProvider);
    final useFetchResultPromotion = useFetchObject<PromotionEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionById(context, voucher!.promotionCategoryId ?? 0),
      context: context,
    );

    final promotion = useFetchResultPromotion.data;

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: ListTile(
        // leading: const Icon(Icons.card_giftcard, color: Colors.orange),
        title: Text(
          promotion!.description ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        trailing: const Icon(Icons.card_giftcard, color: Colors.orange),
        subtitle: Text(
          '- ${formatPrice((voucher?.price?.toInt() ?? 0))}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
