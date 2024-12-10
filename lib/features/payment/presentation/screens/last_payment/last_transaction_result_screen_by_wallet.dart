import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

// Giữ nguyên các hàm định dạng
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

String formatDate(DateTime date) {
  final formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}

String formatTime(DateTime date) {
  final formatter = DateFormat('hh:mm:ss');
  return formatter.format(date);
}

@RoutePage()
class LastTransactionResultScreenByWallet extends HookConsumerWidget {
  final bool? status;
  final int bookingId;
  const LastTransactionResultScreenByWallet({
    super.key,
    required this.bookingId,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double containerWidth = MediaQuery.of(context).size.width * 0.85;

    final state = ref.watch(bookingControllerProvider);
    final useFetchResultOrder = useFetchObject<OrderEntity>(
      function: (context) async {
        return ref
            .read(bookingControllerProvider.notifier)
            .getOrderEntityById(bookingId);
      },
      context: context,
    );
    final result = useFetchResultOrder.data;

    final stateWallet = ref.watch(profileControllerProvider);
    final useFetchResultWallet = useFetchObject<WalletEntity>(
      function: (context) async {
        print('check screen');
        return ref.read(profileControllerProvider.notifier).getWallet(context);
      },
      context: context,
    );
    final walletUser = useFetchResultWallet.isFetchingData
        ? 0
        : useFetchResultWallet.data?.balance ?? 0;
    final resultWallet = useFetchResultWallet.refresh;

    List<BookingDetailResponseEntity> getListSerVices(OrderEntity? order) {
      try {
        final listServicesDetails =
            order!.bookingDetails.where((e) => e.quantity > 0).toList();
        return listServicesDetails;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    final listServices = getListSerVices(result);
    double containerHeight = listServices.length * 800.0;

    return LoadingOverlay(
      isLoading: stateWallet.isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade500],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: containerWidth,
                              // height:  MediaQuery.of(context).size.height * 0.9,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.9,
                              ),
                              height: 550,
                              margin: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 24),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.orange.shade500,
                                        size: containerWidth * 0.1,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        "Thanh toán thành công",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: containerWidth * 0.06,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Column(
                                        children: [
                                          buildTransactionDetailRow(
                                              'Mã đơn hàng',
                                              '${result?.id}',
                                              containerWidth),
                                          const SizedBox(height: 8),
                                          buildTransactionDetailRow(
                                              'Nguồn tiền',
                                              'Ví MoveMate',
                                              containerWidth),
                                          const SizedBox(height: 8),
                                          buildTransactionDetailRow(
                                              'Thời gian giao dịch',
                                              formatDate(result?.updatedAt ??
                                                  DateTime.now()),
                                              containerWidth),
                                          buildTransactionDetailRow(
                                              '',
                                              formatTime(result?.updatedAt ??
                                                  DateTime.now()),
                                              containerWidth * 0.89),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: DashedLine(
                                          color: Colors.grey.shade300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 152,
                                            child: ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount: listServices.length,
                                              itemBuilder: (context, index) {
                                                final serviceDetails =
                                                    listServices[index];
                                                return buildListService(
                                                  serviceDetails.name,
                                                  formatPrice(
                                                      (serviceDetails.price ??
                                                              0)
                                                          .toInt()),
                                                  containerWidth * 0.80,
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: DashedLine(
                                          color: Colors.grey.shade300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          buildTransactionDetailPriceRow(
                                            'Tổng tiền',
                                            formatPrice(
                                                ((result?.total ?? 0)).toInt()),
                                            containerWidth,
                                            false,
                                          ),
                                          const SizedBox(height: 2),
                                          buildTransactionDetailPriceRow(
                                              'Tiền đã đặt cọc',
                                              formatPrice((result?.deposit ?? 0)
                                                  .toInt()),
                                              containerWidth * 0.80,
                                              false),
                                          // Added back the missing row
                                          buildTransactionDetailPriceRow(
                                              'Số tiền còn lại đã thanh toán',
                                              formatPrice(((result?.total ??
                                                          0) -
                                                      (result?.deposit ?? 0))
                                                  .toInt()),
                                              containerWidth * 0.80,
                                              true),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Extra space to ensure the button doesn't cover content
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned button at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade500,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final tabsRouter = context.router.root
                                  .innerRouterOf<TabsRouter>(
                                      TabViewScreenRoute.name);
                              if (tabsRouter != null) {
                                tabsRouter.setActiveIndex(0);
                                context.router.popUntilRouteWithName(
                                    TabViewScreenRoute.name);
                              } else {
                                context.router.pushAndPopUntil(
                                  const TabViewScreenRoute(children: [
                                    HomeScreenRoute(),
                                  ]),
                                  predicate: (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Màn hình chính',
                              style: TextStyle(
                                color: Colors.orange.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: containerWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionDetailRow(
      String title, String value, double containerWidth) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildTransactionDetailPriceRow(
      String title, String value, double containerWidth, bool isBold) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: isBold ? Colors.black : Colors.grey.shade500,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildListService(String title, String value, double containerWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 174, 178, 183),
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final Color color;

  const DashedLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 5.0;
      const dashSpace = 5.0;
      final dashCount =
          (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
      );
    });
  }
}
