import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import for hooks
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/payment/presentation/screens/deposite_payment/transaction_result_screen.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

final paymentMethodProvider =
    StateProvider<PaymentMethodType>((ref) => PaymentMethodType.momo);
// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

// List of available payment methods
final paymentList = [
  PaymentMethodType.momo,
  PaymentMethodType.vnpay,
  PaymentMethodType.payos,
  PaymentMethodType.wallet,
  PaymentMethodType.cash,
];

@RoutePage()
class LastPaymentScreen extends HookConsumerWidget {
  final int id;
  const LastPaymentScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final expandedIndex = useState<int>(-1);
    void toggleDropdown() {
      isExpanded.value = !isExpanded.value;
    }

    final bookingController = ref.read(bookingControllerProvider.notifier);

    // Call refreshBookingData when the widget is first built
    useEffect(() {
      bookingController.refreshBookingData(id: id);
      return null;
    }, []);

    // Access the booking response from the provider
    final bookingResponse = ref.watch(bookingResponseProvider);
// print("object");
    if (bookingResponse == null) {
      // Show a loading indicator while data is being fetched
      return Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          backButtonColor: AssetsConstants.whiteColor,
          title: "Hoàn tất thanh toán",
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
          showBackButton: false,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentController = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    Future<void> handlePaymentButtonPressed() async {
      try {
        if (selectedMethod == PaymentMethodType.wallet) {
          await paymentController.createLastPaymentBookingByWallet(
            context: context,
            selectedMethod: selectedMethod.type,
            bookingId: id,
          );
        } else if (selectedMethod == PaymentMethodType.cash) {
          // await paymentController.createPaymentBooking(
          //   context: context,
          //   selectedMethod: selectedMethod.type,
          //   bookingId: bookingResponse.id.toString(),
          // );
          showSnackBar(
            context: context,
            content: 'Phương thứ này đang bảo trì',
            icon: const Icon(Icons.close),
            backgroundColor: AssetsConstants.mainColor,
            textColor: AssetsConstants.whiteColor,
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
        appBar: const CustomAppBar(
          centerTitle: true,
          backButtonColor: AssetsConstants.whiteColor,
          title: "Hoàn tất thanh toán ",
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   'Thông tin đơn hàng',
                              //   style: TextStyle(
                              //       fontSize: 16, color: Colors.black87),
                              // ),
                              // const Text(
                              //   'số lượng 1',
                              //   style: TextStyle(
                              //       fontSize: 16, color: Colors.black87),
                              // ),
                              // Text(
                              //   bookingResponse.status ?? "",
                              //   style: const TextStyle(
                              //       fontSize: 16, color: Colors.black87),
                              // ),
                            ],
                          ),
                        ),

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
                            Text(
                              'Phương thức thanh toán',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),

                        Column(
                          children: paymentList.map((method) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
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
                                    onChanged: (value) {
                                      if (value != null) {
                                        ref
                                            .read(
                                                paymentMethodProvider.notifier)
                                            .state = value;
                                      }
                                    },
                                    activeColor: const Color(0xFFFF7F00),
                                  ),
                                ],
                              ),
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
                        // Container(
                        //   margin: const EdgeInsets.symmetric(vertical: 10),
                        //   child: const Text(
                        //     'Đơn hàng của quý khách đã được giao đến địa chỉ mà quý khách đã cung cấp. Quý khách vui lòng kiểm tra kỹ số lượng, tình trạng của hàng hóa. \n\nMoveMate xin cảm ơn.',
                        //     style:
                        //         TextStyle(fontSize: 14, color: Colors.black87),
                        //   ),
                        // ),
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(
                                  content: 'Tiền thanh toán',
                                  size: AssetsConstants.labelFontSize * 1.3,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                Row(
                                  children: [
                                    LabelText(
                                      content: formatPrice(
                                          bookingResponse.totalReal.toInt()),
                                      size: AssetsConstants.labelFontSize * 1.3,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    IconButton(
                                      onPressed: toggleDropdown,
                                      icon: Icon(
                                        isExpanded.value
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: const Color(0xFFFF7F00),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (isExpanded.value)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nội dung mở rộng ở đây
                                    ...bookingResponse.bookingDetails
                                        .map<Widget>((detail) {
                                      return _OrderItem(
                                        label: detail.name ?? '',
                                        price:
                                            formatPrice(detail.price.toInt()),
                                      );
                                    }),
                                    // Đường kẻ nét đứt
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: DashedLine(
                                          color: Colors.grey.shade300),
                                    ),
                                    _OrderItem(
                                      label: 'Tiền đặt cọc',
                                      price:
                                          '- ${formatPrice(bookingResponse.deposit.toInt())}',
                                    ),
                                  ],
                                ),
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

class _OrderItem extends StatelessWidget {
  final String label;
  final String price;
  final bool isBold;

  const _OrderItem({
    super.key,
    required this.label,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
