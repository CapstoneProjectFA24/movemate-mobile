import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';

import 'package:movemate/features/promotion/presentation/widgets/promotion_list.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// model
import 'package:movemate/features/promotion/data/models/promotion_model.dart';

@RoutePage()
class PromotionScreen extends HookConsumerWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);

    final List<PromotionModel> fakePromotions = [
      PromotionModel(
        title: 'Giảm tới',
        discount: '50%',
        description: 'Dịch vụ dọn nhà nội thành',
        code: 'DONNAI50',
        imagePath:
            'https://cdn.thuvienphapluat.vn/uploads/tintuc/%E1%BA%A2NH%20TIN%20TUC/chuyen-nha.jpg', // URL hình ảnh mạng
        bgcolor: Colors.deepOrangeAccent,
        propromoPeriod: "01/05/2024 - 31/05/2024",
        minTransaction: "500,000 VND",
        type: "Nội thành",
        destination: "Hà Nội",
      ),
      PromotionModel(
        title: 'Giảm tới',
        discount: '37%',
        description: 'Dịch vụ dọn nhà ngoại thành',
        code: 'DONNGOAI37',
        imagePath:
            'https://cdn.thuvienphapluat.vn/uploads/tintuc/%E1%BA%A2NH%20TIN%20TUC/chuyen-nha.jpg', // URL hình ảnh mạng
        bgcolor: Colors.tealAccent,
        propromoPeriod: "01/06/2024 - 30/06/2024",
        minTransaction: "1,000,000 VND",
        type: "Ngoại thành",
        destination: "Hồ Chí Minh",
      ),
      PromotionModel(
        title: 'Giảm tới',
        discount: '30%',
        description: 'Dọn dẹp văn phòng',
        code: 'VANPHONG30',
        imagePath:
            'https://cdn.thuvienphapluat.vn/uploads/tintuc/%E1%BA%A2NH%20TIN%20TUC/chuyen-nha.jpg', // URL hình ảnh mạng
        bgcolor: Colors.deepPurple,
        propromoPeriod: "01/07/2024 - 31/07/2024",
        minTransaction: "2,000,000 VND",
        type: "Văn phòng",
        destination: "Đà Nẵng",
      ),
      PromotionModel(
        title: 'Giảm tới',
        discount: '25%',
        description: 'Dọn dẹp sau xây dựng',
        code: 'XAYDUNG25',
        imagePath:
            'https://cdn.thuvienphapluat.vn/uploads/tintuc/%E1%BA%A2NH%20TIN%20TUC/chuyen-nha.jpg', // URL hình ảnh mạng
        bgcolor: Colors.lightGreenAccent,
        propromoPeriod: "01/08/2024 - 31/08/2024",
        minTransaction: "3,000,000 VND",
        type: "Sau xây dựng",
        destination: "Cần Thơ",
      ),
    ];

    List<String> tabs = [
      "Tất cả",
      "Khuyến mãi 1",
      "Khuyến mãi 2",
      // "Khuyến mãi 3"
    ];

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
        centerTitle: true,
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
            promotions:
                fakePromotions.where((p) => p.discount.contains('50')).toList(),
          ),
          PromotionList(
            promotions:
                fakePromotions.where((p) => p.discount.contains('25')).toList(),
          ),
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
