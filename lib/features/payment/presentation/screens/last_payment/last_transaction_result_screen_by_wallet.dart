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
    double containerWidth = MediaQuery.of(context).size.width * 0.9;

    // print('allUri: $allUri');

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
    double containerHeight =
        MediaQuery.of(context).size.height * (listServices.length * 0.125);
    return LoadingOverlay(
      isLoading: state.isLoading || stateWallet.isLoading,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    buildTransactionDetailRow(
                                        'Số tiền',
                                        formatPrice(
                                            (result?.totalReal ?? 0).toInt()),
                                        containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow('Phí giao dịch',
                                        'Miễn phí', containerWidth),
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
                              // Chi tiết mã giao dịch
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    buildTransactionDetailRow('Mã giao dịch',
                                        '${result?.id}', containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow('Nguồn tiền',
                                        'Ví MoveMate', containerWidth),
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
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: listServices.length,
                                        itemBuilder: (context, index) {
                                          final serviceDetails =
                                              listServices[index];
                                          return buildTransactionDetailRow(
                                            serviceDetails.name,
                                            formatPrice(
                                                (serviceDetails.price ?? 0)
                                                    .toInt()),
                                            containerWidth * 0.80,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        // Thông tin số dư ví - Đặt bên dưới container chính
                        // Container(
                        //   width: containerWidth,
                        //   margin: const EdgeInsets.symmetric(horizontal: 24),
                        //   padding: const EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         width: 40,
                        //         height: 40,
                        //         margin: const EdgeInsets.only(right: 8),
                        //         decoration: const BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //             image: NetworkImage(
                        //                 'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1731511719/movemate_logo_e6f1lk.png'),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               'Số dư ví MoveMate',
                        //               style: TextStyle(
                        //                 fontSize: containerWidth * 0.045,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //             Text(
                        //               formatPrice(walletUser.toInt()),
                        //               style: TextStyle(
                        //                 fontSize: containerWidth * 0.045,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 24),
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
                        // const SizedBox(width: 16),
                        // Expanded(
                        //   child: SizedBox(
                        //     height: 48,
                        //     child: ElevatedButton(
                        //       // onPressed: () {
                        //       //   context.router
                        //       //       .push(const TransactionDetailsOrderRoute());
                        //       // },

                        //       onPressed: () async {
                        //         // Trích xuất phần số nguyên từ bookingId để lấy id

                        //         final id = bookingId;

                        //         // Sử dụng BookingController để lấy OrderEntity
                        //         final bookingController = ref
                        //             .read(bookingControllerProvider.notifier);
                        //         final orderEntity = await bookingController
                        //             .getOrderEntityById(id);

                        //         if (orderEntity != null) {
                        //           // Điều hướng đến OrderDetailsScreen với orderEntity
                        //           context.router.replaceAll([
                        //             OrderDetailsScreenRoute(order: orderEntity)
                        //           ]);
                        //         } else {
                        //           // Xử lý lỗi nếu không tìm thấy OrderEntity
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //                 content: Text(
                        //                     'Không tìm thấy thông tin đơn hàng')),
                        //           );
                        //         }
                        //       },

                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.orange.shade800,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8),
                        //         ),
                        //       ),
                        //       child: Text(
                        //         'Chi tiết đơn hàng',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: containerWidth * 0.045,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: containerWidth * 0.045),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: containerWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
