import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';

import 'package:movemate/features/promotion/presentation/widgets/promotion_list.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// model
import 'package:movemate/features/promotion/data/models/promotion_model.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

@RoutePage()
class PromotionScreen extends HookConsumerWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final size = MediaQuery.sizeOf(context);

    final state = ref.watch(promotionControllerProvider);

    final useFetchResult = useFetchObject<PromotionAboutUserEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionNoUser(context),
      context: context,
    );
    final promotionAboutUser = useFetchResult.data;

    final promotionUserNotGet = promotionAboutUser?.promotionNoUser ?? [];

    List<String> tabs = [
      "Tất cả",
      "Hiện tại",
      "Sắp tới",
      // "Khuyến mãi 3"
    ];

    ref.listen<bool>(refreshPromotion, (_, __) => useFetchResult.refresh());

    useEffect(() {
      ref.listen<bool>(refreshPromotion, (_, __) => useFetchResult.refresh());
      return null;
    }, []);

// Lấy ngày và giờ hiện tại
    DateTime now = DateTime.now();

// Lọc danh sách các promotions thỏa mãn điều kiện ngày hiện tại nằm trong khoảng startDate và endDate
    List<PromotionEntity> activePromotions = promotionUserNotGet.where((p) {
      // Kiểm tra xem ngày hiện tại có nằm trong khoảng từ startDate đến endDate hay không
      return (now.isAfter(p.startDate) || now.isAtSameMomentAs(p.startDate)) &&
          (now.isBefore(p.endDate) || now.isAtSameMomentAs(p.endDate));
    }).toList();
// Lọc danh sách các promotions thỏa mãn điều kiện ngày hiện tại +30 nằm trong khoảng startDate và endDate
    List<PromotionEntity> activePromotionsFuture =
        promotionUserNotGet.where((p) {
      // Kiểm tra xem ngày hiện tại có nằm trong khoảng từ startDate đến endDate hay không
      return (now.isAfter(p.startDate) || now.isAtSameMomentAs(p.startDate)) &&
          (now.isBefore(p.endDate) || now.isAtSameMomentAs(p.endDate));
    }).toList();

// Hàm để lấy ngày đầu tiên và cuối cùng của tháng sau
    DateTime getNextMonthStart(DateTime date) {
      int year = date.month == 12 ? date.year + 1 : date.year;
      int month = date.month == 12 ? 1 : date.month + 1;
      return DateTime(year, month, 1);
    }

    DateTime getNextMonthEnd(DateTime date) {
      DateTime nextMonthStart = getNextMonthStart(date);
      DateTime followingMonthStart = DateTime(
        nextMonthStart.month == 12
            ? nextMonthStart.year + 1
            : nextMonthStart.year,
        nextMonthStart.month == 12 ? 1 : nextMonthStart.month + 1,
        1,
      );
      return followingMonthStart.subtract(const Duration(seconds: 1));
    }

// Xác định khoảng thời gian của tháng sau
    DateTime nextMonthStart = getNextMonthStart(now);
    DateTime nextMonthEnd = getNextMonthEnd(now);

// Lọc danh sách các promotions thỏa mãn điều kiện có giao với tháng sau
    List<PromotionEntity> nextMonthPromotions = promotionUserNotGet.where((p) {
      // Kiểm tra xem khoảng thời gian promotion có giao với tháng sau không
      return p.startDate.isBefore(nextMonthEnd) &&
          p.endDate.isAfter(nextMonthStart);
    }).toList();

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          backgroundColor: AssetsConstants.primaryMain,
          title: "Khuyến mãi",
          centerTitle: true,
          iconFirst: Icons.refresh,
          onCallBackFirst: () {
            useFetchResult.refresh();
          },
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(50.0),
          //   child: Container(
          //     color: Colors.white,
          //     child: TabBar(
          //       controller: tabController,
          //       indicatorColor: Colors.orange,
          //       indicatorWeight: 2,
          //       labelColor: Colors.orange,
          //       unselectedLabelColor: Colors.grey,
          //       tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          //     ),
          //   ),
          // ),
        ),
        body: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            (state.isLoading && useFetchResult.isFetchingData)
                ? const Center(
                    child: HomeShimmer(amount: 4),
                  )
                : (useFetchResult.isFetchingData)
                    ? const Align(
                        alignment: Alignment.topCenter,
                        child: EmptyBox(title: ''),
                      )
                    : Expanded(
                        child: PromotionList(promotions: promotionUserNotGet),

                        // TabBarView(
                        //   controller: tabController,
                        //   children: [
                        //     PromotionList(promotions: promotionUserNotGet),
                        //     PromotionList(
                        //       promotions: activePromotions,
                        //     ),
                        //     PromotionList(
                        //       promotions: nextMonthPromotions,
                        //     ),
                        //   ],
                        // ),
                      ),
          ],
        ),
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
