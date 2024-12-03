import 'package:flutter/material.dart';

// app route
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
//

import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/widgets/promotion_card.dart';

class PromotionList extends StatefulWidget {
  final List<PromotionEntity> promotions;

  const PromotionList({super.key, required this.promotions});

  @override
  State<PromotionList> createState() => _PromotionListState();
}

class _PromotionListState extends State<PromotionList> {
  final Set<int> _redeemedPromotions = {};
  final List<String> _vouchers = [];

  void _redeemPromotion(PromotionEntity promotion, int index) {
    if (!_redeemedPromotions.contains(index)) {
      setState(() {
        _redeemedPromotions.add(index);
        _vouchers.add(promotion.id.toString());
      });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.promotions.length,
            itemBuilder: (context, index) {
              final promotion = widget.promotions[index];
              return GestureDetector(
                onTap: () => _redeemPromotion(promotion, index),
                //optional choice 2 details
                // onTap: () => context.router
                //     .push(PromotionDetailScreenRoute(promotion: promotion)),
                // onTap: () => context.router
                //     .push(CouponDetailScreenRoute(promotion: promotion)),
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
              CartVoucherScreenRoute(vouchers: _vouchers),
            );
          },
          child: const Text('Xem giỏ hàng'),
        ),
      ],
    );
  }
}
