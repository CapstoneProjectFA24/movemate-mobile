import 'package:flutter/material.dart';

//app route
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
//

import 'package:movemate/features/promotion/domain/models/promotion_model.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/promotion_card.dart';

class PromotionList extends StatelessWidget {
  final List<PromotionModel> promotions;

  const PromotionList({super.key, required this.promotions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final promotion = promotions[index];
        return GestureDetector(
          onTap: () => context.router.push(
            PromotionDetailScreenRoute(promotion: promotion),
          ),
          child: PromotionCard(
            promotion: promotion,
          ),
        );
      },
    );
  }
}
