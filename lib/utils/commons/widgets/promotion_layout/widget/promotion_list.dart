import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/promotion/presentation/promotion_details.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_card.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_provider.dart';

class PromotionList extends HookConsumerWidget {
  const PromotionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Promotion provider (this could be updated dynamically via API)
    final promotions = ref.watch(promotionProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final promotion = promotions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PromotionDetails(promotion: promotion),
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: PromotionCard(promotion: promotion),
        );
      },
    );
  }
}
