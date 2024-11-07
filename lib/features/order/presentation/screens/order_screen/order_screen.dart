import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/orderItem.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';

@RoutePage()
class OrderScreen extends HookConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();
    final state = ref.watch(orderControllerProvider);

    final fetchReslut = useFetch<OrderEntity>(
      function: (model, context) => ref
          .read(orderControllerProvider.notifier)
          .getBookings(model, context),
      initialPagingModel: PagingModel(
          // pageNumber: 2,
          // ví dụ ở đây và trong widgetshowCustomButtom ở widget test floder luôn

          // filterSystemContent:  ref.read(filterSystemStatus).type,
          // filterContent: ref.read(filterPartnerStatus).type,
          // searchDateFrom: dateFrom,
          // searchDateTo: dateTo,
          ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchReslut.loadMore);

      //  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   if (message.data['screen'] == OrderDetailScreenRoute.name) {
      //     fetchResult.refresh();
      //   }

      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách đặt dịch vụ',
        // iconFirst: Icons.refresh_rounded,
        centerTitle: true,
        backgroundColor: AssetsConstants.primaryMain,
        // iconSecond: Icons.filter_list_alt,
        // onCallBackFirst: fetchReslut.refresh,
        // onCallBackSecond: () => {
        //   //show filter bottom or tom
        // },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.02),
          (state.isLoading && fetchReslut.items.isEmpty)
              ? const Center(
                  child: HomeShimmer(amount: 4),
                )
              : fetchReslut.items.isEmpty
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: EmptyBox(title: ''),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: fetchReslut.items.length + 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AssetsConstants.defaultPadding - 10.0,
                        ),
                        itemBuilder: (_, index) {
                          if (index == fetchReslut.items.length) {
                            if (fetchReslut.isFetchingData) {
                              return const CustomCircular();
                            }
                            return fetchReslut.isLastPage
                                ? const NoMoreContent()
                                : Container();
                          }
                          return OrderItem(
                            order: fetchReslut.items[index],
                            onCallback: fetchReslut.refresh,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
