import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/features/promotion/presentation/widgets/voucher_item.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

@RoutePage()
class CartVoucherScreen extends HookConsumerWidget {
  // final List<String> vouchers;

  const CartVoucherScreen({
    super.key,
    // required this.vouchers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promotionControllerProvider);
    final useFetchResult = useFetchObject<PromotionAboutUserEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionNoUser(context),
      context: context,
    );
    final promotionAboutUser = useFetchResult.data;

    final promotionUserGot = promotionAboutUser?.promotionUser ?? [];

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E0), // Light orange background
        appBar: AppBar(
          title: Text(
            'Mã Voucher Của Tôi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.orange[900]),
        ),
        body: promotionUserGot.isEmpty
            ? _buildEmptyVoucherState(context)
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.separated(
                  itemCount: promotionUserGot.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final promotion = promotionUserGot[index];
                    return VoucherItem(
                      promotionUserGot: promotion,
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyVoucherState(
    BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard,
            size: 200,
            color: Colors.orange[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Bạn chưa có mã voucher nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange[900],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to voucher collection

              final tabsRouter = context.router.root
                  .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
              if (tabsRouter != null) {
                tabsRouter.setActiveIndex(2);
                context.router.popUntilRouteWithName(TabViewScreenRoute.name);
              } else {
                context.router.pushAndPopUntil(
                  const TabViewScreenRoute(children: [
                    PromotionScreenRoute(),
                  ]),
                  predicate: (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Khám phá Voucher',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
