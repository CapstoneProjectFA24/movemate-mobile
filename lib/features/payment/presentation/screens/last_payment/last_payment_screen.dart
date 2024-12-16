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
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
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

    final wallet = ref.read(walletProvider);
    final bookingAsync = ref.watch(bookingStreamProvider(id.toString()));
    final checkIsCredit = bookingAsync.value?.isCredit;

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

    // Nếu checkIsCredit là true và phương thức thanh toán hiện tại không phải là cash, chuyển sang cash
    useEffect(() {
      if (checkIsCredit == true && selectedMethod != PaymentMethodType.cash) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(paymentMethodProvider.notifier).state =
              PaymentMethodType.cash;
        });
      }
      return null;
    }, [checkIsCredit, selectedMethod]);

    Future<void> handlePaymentButtonPressed() async {
      try {
        if (selectedMethod == PaymentMethodType.wallet) {
          await paymentController.createLastPaymentBookingByWallet(
            context: context,
            selectedMethod: selectedMethod.type,
            bookingId: id,
          );
        } else if (selectedMethod == PaymentMethodType.cash) {
          await paymentController.paymentBookingCash(
              context: context, bookingId: id);
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
                            children: [],
                          ),
                        ),

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
                            // Xác định xem phương thức này có được phép chọn hay không
                            // bool isDisabled = checkIsCredit == true &&
                            //     method != PaymentMethodType.cash;

                            // Check both credit and wallet lock conditions
                            bool isDisabled = (checkIsCredit == true &&
                                    method != PaymentMethodType.cash) ||
                                (method == PaymentMethodType.wallet &&
                                    wallet?.isLocked == true);

                            bool showWalletLockMessage =
                                method == PaymentMethodType.wallet &&
                                    wallet?.isLocked == true;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Opacity(
                                  opacity: isDisabled ? 0.5 : 1.0,
                                  child: IgnorePointer(
                                    ignoring: isDisabled,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
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
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isDisabled
                                                  ? Colors.grey
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          Radio<PaymentMethodType>(
                                            value: method,
                                            groupValue: selectedMethod,
                                            onChanged: isDisabled
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
                                            activeColor:
                                                const Color(0xFFFF7F00),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (showWalletLockMessage)
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 4, bottom: 8),
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
                                          (bookingResponse.totalReal)
                                              .toDouble()),
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
                                        price: formatPrice(
                                            detail.price.toDouble()),
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
                                          '- ${formatPrice(bookingResponse.deposit.toDouble())}',
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
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.0, // Adjust font size as needed
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis, // Adds ellipsis if text exceeds
            ),
          ),
          const SizedBox(width: 16),
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
