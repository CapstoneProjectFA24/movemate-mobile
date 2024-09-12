import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';

import 'package:movemate/utils/commons/widgets/promotion_layout/promotion_list.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// model
import 'package:movemate/features/promotion/domain/models/promotion_model.dart';

@RoutePage()
class PromotionScreen extends HookConsumerWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);

    final List<PromotionModel> fakePromotions = [
      PromotionModel(
        title: 'Up to',
        discount: '50% Off',
        description: 'On domestic flights',
        code: 'DOMESTIC50',
        imagePath: 'assets/images/promotion/Ellipse171.png',
        bgcolor: Colors.deepOrangeAccent,
        propromoPeriod: "123",
        minTransaction: "123",
        type: "123",
        destination: "123",
      ),
      PromotionModel(
        title: 'Up to',
        discount: '37% Off',
        description: 'On international flights',
        code: 'INTERNATIONAL37',
        imagePath: 'assets/images/promotion/Ellipse171.png',
        bgcolor: Colors.tealAccent,
        propromoPeriod: "123",
        minTransaction: "123",
        type: "123",
        destination: "123",
      ),
      PromotionModel(
        title: 'Up to',
        discount: '30% Off',
        description: 'On train tickets',
        code: 'TRAIN30',
        imagePath: 'assets/images/promotion/Ellipse171.png',
        bgcolor: Colors.deepPurple,
        propromoPeriod: "123",
        minTransaction: "123",
        type: "123",
        destination: "123",
      ),
      PromotionModel(
        title: 'Up to',
        discount: '25% Off',
        description: 'On hotel bookings',
        code: 'HOTEL25',
        imagePath: 'assets/images/promotion/Ellipse171.png',
        bgcolor: Colors.lightGreenAccent,
        propromoPeriod: "123",
        minTransaction: "123",
        type: "123",
        destination: "123",
      ),
    ];

    List<String> tabs = ["Tất cả", "Sale 1", "Sale 2", "Sale 3"];

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });
      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        title: "Khuyến mãi",
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.orange,
              indicatorWeight: 2,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          PromotionList(promotions: fakePromotions),
          PromotionList(
            promotions: fakePromotions
                .where((p) => p.code.contains('DOMESTIC'))
                .toList(),
          ),
          const _TabContent(content: 'Trains Deals'),
          const _TabContent(content: 'Hotels Deals'),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String content;

  const _TabContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
