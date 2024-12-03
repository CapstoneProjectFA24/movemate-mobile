import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import thư viện hooks_riverpod
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/features/promotion/presentation/widgets/promotion_card.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';

class PromotionList extends HookConsumerWidget {
  final List<PromotionEntity> promotions;

  const PromotionList({super.key, required this.promotions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng useState để quản lý state (set redeemed promotions và vouchers)
    final redeemedPromotions = useState<Set<int>>({});
    final vouchers = useState<List<String>>([]);
    final state = ref.watch(promotionControllerProvider);

    final useFetchResult = useFetchObject<PromotionAboutUserEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionNoUser(context),
      context: context,
    );
    // Function redeemPromotion
    void redeemPromotion(PromotionEntity promotion, int index) {
      if (!redeemedPromotions.value.contains(index)) {
        redeemedPromotions.value = {
          ...redeemedPromotions.value,
          index
        }; // Thêm vào redeemedPromotions
        vouchers.value = [
          ...vouchers.value,
          promotion.id.toString()
        ]; // Thêm vào vouchers

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bạn đã nhận được mã: ${promotion.name}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bạn đã nhận mã này rồi!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return GestureDetector(
                // onTap: () => redeemPromotion(promotion, index),
                onTap: () async {
                  await ref
                      .read(promotionControllerProvider.notifier)
                      .postVouherForUser(context, promotion.id);
// Sau khi nhận voucher, làm mới danh sách
                  useFetchResult.refresh();
                  redeemPromotion(promotion, index);
                },
                child: PromotionCard(
                  promotion: promotion,
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.router.push(
              CartVoucherScreenRoute(vouchers: vouchers.value),
            );
          },
          child: const Text('Xem giỏ hàng'),
        ),
      ],
    );
  }
}
