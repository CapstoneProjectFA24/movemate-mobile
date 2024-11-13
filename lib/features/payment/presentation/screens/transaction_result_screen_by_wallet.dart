import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
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
class TransactionResultScreenByWallet extends HookConsumerWidget {
  final String bookingId;
  final bool isSuccess;
  const TransactionResultScreenByWallet({
    super.key,
    required this.isSuccess,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.5;
    // print('allUri: $allUri');
    int? bookingIdInt = int.tryParse(bookingId);
    //{isSuccess: true, amount: 312000, payDate: 11/07/2024 23:36:49, bookingId: 426-a66aec19-e687-427b-a836-ee65150cbc1b, transactionCode: 4223169412, userId: 3, paymentMethod: Momo}
    final state = ref.watch(bookingControllerProvider);
    final useFetchResultOrder = useFetchObject<OrderEntity>(
      function: (context) async {
        return ref
            .read(bookingControllerProvider.notifier)
            .getOrderEntityById(bookingIdInt ?? 0);
      },
      context: context,
    );
    final result = useFetchResultOrder.data;
    print("check object ${result?.deposit}");

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
                                  'Đặt cọc thành công',
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
                                            (result?.deposit ?? 0).toInt()),
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
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        // Thông tin số dư ví - Đặt bên dưới container chính
                        Container(
                          width: containerWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1731511719/movemate_logo_e6f1lk.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số dư ví MoveMate',
                                      style: TextStyle(
                                        fontSize: containerWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatPrice(walletUser.toInt()),
                                      style: TextStyle(
                                        fontSize: containerWidth * 0.045,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                  // Pop back to the TabViewScreen
                                  context.router.popUntilRouteWithName(
                                      TabViewScreenRoute.name);
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              // onPressed: () {
                              //   context.router
                              //       .push(const TransactionDetailsOrderRoute());
                              // },

                              onPressed: () async {
                                // Trích xuất phần số nguyên từ bookingId để lấy id
                                final idPart = bookingId.split('-').first;
                                final id = int.tryParse(idPart);

                                if (id != null) {
                                  // Sử dụng BookingController để lấy OrderEntity
                                  final bookingController = ref
                                      .read(bookingControllerProvider.notifier);
                                  final orderEntity = await bookingController
                                      .getOrderEntityById(id);

                                  if (orderEntity != null) {
                                    // Điều hướng đến OrderDetailsScreen với orderEntity
                                    context.router.push(OrderDetailsScreenRoute(
                                        order: orderEntity));
                                  } else {
                                    // Xử lý lỗi nếu không tìm thấy OrderEntity
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Không tìm thấy thông tin đơn hàng')),
                                    );
                                  }
                                } else {
                                  // Xử lý lỗi nếu không thể trích xuất id
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Không thể lấy id từ bookingId')),
                                  );
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Chi tiết đơn hàng',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: containerWidth * 0.045,
                                  color: Colors.white,
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
