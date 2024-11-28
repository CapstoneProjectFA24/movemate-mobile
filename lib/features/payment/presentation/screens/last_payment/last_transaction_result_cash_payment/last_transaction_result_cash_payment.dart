import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

// Hàm hỗ trợ để định dạng ngày tháng
String formatDate(DateTime date) {
  final formatter =
      DateFormat('dd-MM-yyyy'); // Định dạng ngày theo 'ngày-tháng-năm'
  return formatter.format(date);
}

// Hàm hỗ trợ để định dạng giờ
String formatTime(DateTime date) {
  final formatter =
      DateFormat('hh:mm:ss'); // Định dạng ngày theo 'ngày-tháng-năm'
  return formatter.format(date);
}

@RoutePage()
class LastTransactionResultCashPayment extends HookConsumerWidget {
  final bool? status;
  final OrderEntity? order;
  const LastTransactionResultCashPayment({
    super.key,
    required this.order,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double containerWidth = MediaQuery.of(context).size.width * 0.85;

    // print('allUri: $allUri');

    final result = order;

//---//
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
    double containerHeight = listServices.length * 108.0;
    return LoadingOverlay(
      isLoading: stateWallet.isLoading,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container chính
                        Container(
                          width: containerWidth,
                          height: containerHeight,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),
                              // Biểu tượng thành công
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
                                  size: containerWidth *
                                      0.1, // Tăng kích thước icon dựa trên chiều rộng container
                                ),
                              ),
                              // Tiêu đề
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Thanh toán thành công",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.orange.shade500,
                                    fontWeight: FontWeight.bold,
                                    fontSize: containerWidth *
                                        0.06, // Điều chỉnh kích thước phông chữ theo chiều rộng container
                                  ),
                                ),
                              ),
                              // Thông tin giao dịch

                              // Chi tiết mã giao dịch
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    buildTransactionDetailRow('Mã đơn hàng',
                                        '${result?.id}', containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow('Nguồn tiền',
                                        'Tiền mặt', containerWidth),
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
                              // Đường kẻ nét đứt
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: DashedLine(color: Colors.grey.shade300),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 152,
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(), // Cho phép cuộn
                                        itemCount: listServices.length,
                                        itemBuilder: (context, index) {
                                          final serviceDetails =
                                              listServices[index];
                                          return buildListService(
                                            serviceDetails.name,
                                            formatPrice(
                                                (serviceDetails.price ?? 0)
                                                    .toInt()),
                                            containerWidth * 0.80,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Đường kẻ nét đứt
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: DashedLine(color: Colors.grey.shade300),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
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
                                        formatPrice(
                                            (result?.deposit ?? 0).toInt()),
                                        containerWidth * 0.80,
                                        false),
                                    buildTransactionDetailPriceRow(
                                        'Số tiền còn lại đã thanh toán',
                                        formatPrice(((result?.total ?? 0) -
                                                (result?.deposit ?? 0))
                                            .toInt()),
                                        containerWidth * 0.80,
                                        true),
                                  ],
                                ),
                              ),

                              // const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Buttons container at bottom
                Container(
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
                              // Example of a button to navigate to the Home tab

                              // Navigating to Home screen within TabViewScreen

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
              ],
            ),
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
        children: [
          Expanded(
            flex: 5, // Allocate space for the title
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              softWrap: true, // Allow wrapping
              overflow: TextOverflow.visible, // Ensure text is not clipped
            ),
          ),
          const SizedBox(width: 10), // Add spacing between title and value
          Expanded(
            flex: 2, // Allocate space for the value
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 174, 178, 183),
              ),
              softWrap: true, // Allow wrapping
              overflow: TextOverflow.visible, // Ensure text is not clipped
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
