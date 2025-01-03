import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import for hooks
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';

final paymentMethodProvider =
    StateProvider<PaymentMethodType>((ref) => PaymentMethodType.momo);

// List of available payment methods
final paymentList = [
  PaymentMethodType.momo,
  PaymentMethodType.vnpay,
  PaymentMethodType.payos,
  PaymentMethodType.wallet,
];

@RoutePage()
class PaymentScreen extends HookConsumerWidget {
  final int id;

  const PaymentScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingController = ref.read(bookingControllerProvider.notifier);

    final wallet = ref.read(walletProvider);

    // Call refreshBookingData when the widget is first built
    // useEffect(() {
    //   bookingController.refreshBookingData(id: id);
    //   return null;
    // }, []);

    // Access the booking response from the provider
    final bookingResponse = ref.watch(bookingResponseProvider);
// print("object");
    if (bookingResponse == null) {
      // Show a loading indicator while data is being fetched
      return Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          backButtonColor: AssetsConstants.whiteColor,
          title: "Thanh Toán Đặt Cọc",
          iconFirst: Icons.home,
          onCallBackFirst: () {
            final tabsRouter = context.router.root
                .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
            if (tabsRouter != null) {
              tabsRouter.setActiveIndex(0);
              context.router.popUntilRouteWithName(TabViewScreenRoute.name);
            } else {
              context.router.pushAndPopUntil(
                const TabViewScreenRoute(children: [
                  HomeScreenRoute(),
                ]),
                predicate: (route) => false,
              );
            }
          },
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentController = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    Future<void> handlePaymentButtonPressed() async {
      try {
        if (selectedMethod == PaymentMethodType.wallet &&
            wallet?.isLocked == false) {
          await paymentController.createPaymentBookingByWallet(
            context: context,
            selectedMethod: selectedMethod.type,
            bookingId: id,
          );
        } else {
          await paymentController.createPaymentBooking(
            context: context,
            selectedMethod: selectedMethod.type,
            bookingId: bookingResponse.id.toString(),
          );
        }
      } catch (e) {
        print("Payment failed: $e");
      }
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          backButtonColor: AssetsConstants.whiteColor,
          title: "Thanh Toán Đặt Cọc",
          iconFirst: Icons.home,
          onCallBackFirst: () {
            final tabsRouter = context.router.root
                .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
            if (tabsRouter != null) {
              tabsRouter.setActiveIndex(0);
              // Pop back to the TabViewScreen
              context.router.popUntilRouteWithName(TabViewScreenRoute.name);
            }
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Details
                        // Container(
                        //   margin: const EdgeInsets.symmetric(vertical: 10),
                        //   child: const Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Thông tin đơn hàng',
                        //         style: TextStyle(
                        //             fontSize: 16, color: Colors.black87),
                        //       ),
                        //       // const Text(
                        //       //   'số lượng 1',
                        //       //   style: TextStyle(
                        //       //       fontSize: 16, color: Colors.black87),
                        //       // ),
                        //       // Text(
                        //       //   bookingResponse.status ?? "",
                        //       //   style: const TextStyle(
                        //       //       fontSize: 16, color: Colors.black87),
                        //       // ),
                        //     ],
                        //   ),
                        // ),

                        // Date
                        // Container(
                        //   margin: const EdgeInsets.only(bottom: 10),
                        //   child: Text(
                        //     bookingResponse.createdAt ?? "",
                        //     style: const TextStyle(
                        //         fontSize: 16, color: Colors.black87),
                        //   ),
                        // ),

                        // Payment Method Section
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: Text('Chọn phương thức đặt cọc: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    )))
                            // TextButton(
                            //   onPressed: () {
                            //     // Handle 'View All' action
                            //   },
                            //   child: const Text(
                            //     'Xem tất cả',
                            //     style: TextStyle(
                            //       color: Color(0xFFFF7F00),
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        Column(
                          children: paymentList.map((method) {
                            bool isWalletLocked =
                                method == PaymentMethodType.wallet &&
                                    wallet?.isLocked == true;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        method.imageUrl,
                                        width: 40,
                                        height: 40,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        method.displayName,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Spacer(),
                                      Radio<PaymentMethodType>(
                                        value: method,
                                        groupValue: selectedMethod,
                                        onChanged: isWalletLocked
                                            ? null
                                            : (value) {
                                                if (value != null) {
                                                  ref
                                                      .read(
                                                          paymentMethodProvider
                                                              .notifier)
                                                      .state = value;
                                                }
                                              },
                                        activeColor: const Color(0xFFFF7F00),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isWalletLocked)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 4),
                                    child: Text(
                                      "Ví chưa được mở khóa",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),

                        // Coupon Section
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: TextField(
                        //         decoration: InputDecoration(
                        //           hintText: 'Bạn có 7 mã coupons',
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(5),
                        //           ),
                        //           contentPadding: const EdgeInsets.symmetric(
                        //             horizontal: 10,
                        //             vertical: 10,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10),
                        //     OutlinedButton(
                        //       onPressed: () {},
                        //       style: OutlinedButton.styleFrom(
                        //         side:
                        //             const BorderSide(color: Color(0xFFFF7F00)),
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 20,
                        //           vertical: 10,
                        //         ),
                        //       ),
                        //       child: const Text(
                        //         'Thêm',
                        //         style: TextStyle(color: Color(0xFFFF7F00)),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // Note
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Để đảm bảo quá trình chuyển nhà được thực hiện, chúng tôi sẽ thu trước một phần phí đặt cọc dựa trên tổng giá trị đơn hàng của bạn.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Total and Complete Button at the bottom
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const LabelText(
                              content: 'Tiền đặt cọc',
                              size: AssetsConstants.labelFontSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            Row(
                              children: [
                                LabelText(
                                  content: formatPrice(
                                      bookingResponse.deposit.toDouble()),
                                  size: AssetsConstants.labelFontSize * 1.2,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    '',
                                    style: TextStyle(color: Color(0xFFFF7F00)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: ElevatedButton(
                        onPressed: handlePaymentButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7F00),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'Hoàn tất thanh toán bằng ${selectedMethod.displayName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
