import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/modal_action/reviewed_to_coming_modal.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/accept_pause.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/cancel_button.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/voucher_in_order.dart';
import 'package:movemate/features/order/presentation/widgets/review_at_home/services_card_at_home.dart';
import 'package:movemate/features/order/presentation/widgets/review_online/services_card.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/presentation/widgets/details/item.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class PriceDetails extends HookConsumerWidget {
  final OrderEntity order;
  final AsyncValue<BookingStatusType> statusAsync;
  final ServicesPackageEntity? serviceData;
  // final List<VouchersRealtimeEntity> listVoucher;
  const PriceDetails({
    super.key,
    required this.order,
    required this.serviceData,
    required this.statusAsync,
    // required this.listVoucher,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    final stateBooking = ref.watch(bookingControllerProvider);
    final stateOldBooking = ref.watch(orderControllerProvider);

    final orderEntity = useFetchObject<OrderEntity>(
        function: (context) async {
          return ref
              .read(bookingControllerProvider.notifier)
              .getOrderEntityById(order.id);
        },
        context: context);

    final useFetcholdOrder = useFetchObject<OrderEntity>(
      function: (context) => ref
          .read(orderControllerProvider.notifier)
          .getBookingOldById(order.id, context),
      context: context,
    );

    final useFetcholdOrderNew = useFetchObject<OrderEntity>(
      function: (context) => ref
          .read(orderControllerProvider.notifier)
          .getBookingNewById(order.id, context),
      context: context,
    );

    // print('log care order new ${useFetcholdOrderNew.data?.isDeposited}');
    final orderOld = useFetcholdOrder.data;

    final orderObj = orderEntity.data;

    final orderNew = useFetcholdOrderNew.data;
    // print('check newOrder : ${orderNew?.houseTypeId}');

    useEffect(() {
      orderEntity.refresh();

      return null;
    }, [bookingAsync.value?.totalReal]);

    useEffect(() {
      useFetcholdOrderNew.refresh();
      return null;
    }, [bookingAsync.value?.status]);

    useEffect(() {
      return null;
    }, [bookingStatus.canReviewSuggestion]);

    // print("check data 1${orderObj?.bookingDetails.length}");
    // print("check data 2${orderOld?.bookingDetails.length}");
// Kiểm tra điều kiện và gán giá trị cho biến orderData
    final orderData = bookingStatus.canReviewSuggestion ? orderObj : orderOld;
    // print("check data 3 ${orderData?.bookingDetails.length}");

    if (orderData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    void handleActionPress() async {
      if (order.isReviewOnline) {
        // Online Flow: Review -> Payment
        if (bookingStatus.canReviewSuggestion ||
            bookingStatus.isOnlineReviewing ||
            bookingStatus.isOnlineSuggestionReady) {
          final bookingController =
              ref.read(bookingControllerProvider.notifier);
          final orderEntity =
              await bookingController.getOrderEntityById(order.id);
          context.pushRoute(ReviewOnlineRoute(
              order: orderEntity ?? order, orderOld: orderOld));
        } else if (bookingStatus.canMakePayment) {
          // context.pushRoute(PaymentScreenRoute(id: order.id));
          final bookingController =
              ref.read(bookingControllerProvider.notifier);
          final orderEntity =
              await bookingController.getOrderEntityById(order.id);
          context.pushRoute(ReviewOnlineRoute(
              order: orderEntity ?? order, orderOld: orderOld));
        } else if (bookingStatus.canMakePaymentLast) {
          context.pushRoute(ConfirmLastPaymentRoute(
            orderObj: orderObj,
            id: order.id,
          ));
        }
      } else {
        // Offline Flow: Schedule -> Payment -> Review
        if (bookingStatus.canAcceptSchedule) {
          final bookingController =
              ref.read(bookingControllerProvider.notifier);
          final orderEntity =
              await bookingController.getOrderEntityById(order.id);
          context.pushRoute(ReviewAtHomeRoute(order: orderEntity ?? order));
        } else if (bookingStatus.canReviewSuggestion) {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                ReviewedToComingModal(order: order),
          );
        } else if (bookingStatus.canMakePayment || bookingStatus.isWaiting) {
          final bookingController =
              ref.read(bookingControllerProvider.notifier);
          final orderEntity =
              await bookingController.getOrderEntityById(order.id);
          context.router.push(ReviewAtHomeRoute(order: orderEntity ?? order));
        } else if (bookingStatus.canMakePaymentLast) {
          context.pushRoute(ConfirmLastPaymentRoute(
            orderObj: orderObj,
            id: order.id,
          ));
        }
      }
    }

    String getActionButtonText() {
      if (order.isReviewOnline) {
        // Online Flow
        if (bookingStatus.canReviewSuggestion) {
          return 'Xác nhận đánh giá';
        } else if (bookingStatus.canMakePayment) {
          // return 'Thanh toán ngay';
          return 'Xem đề xuất';
        } else if (bookingStatus.canMakePaymentLast) {
          return 'Xác nhận thanh toán';
        }
      } else {
        // Offline Flow
        if (bookingStatus.canAcceptSchedule) {
          return 'Xem lịch khảo sát';
        } else if (bookingStatus.canReviewSuggestion) {
          return 'Xem xét đề xuất';
        } else if (bookingStatus.canMakePayment) {
          return 'Thanh toán';
        } else if (bookingStatus.canMakePaymentLast) {
          return 'Xác nhận thanh toán';
        }
      }
      return '';
    }

    bool isCancelEnabled() {
      return bookingStatus.canCanceled;
    }

    bool isActionEnabled() {
      return bookingStatus.canMakePayment ||
          bookingStatus.canReviewSuggestion ||
          bookingStatus.canAcceptSchedule ||
          bookingStatus.canMakePaymentLast;
      // bookingStatus.isOnlineReviewing ||
      // bookingStatus.isOnlineSuggestionReady;
      // bookingStatus.canConfirmCompletion;
    }

    // print('log care order ${order.vouchers?.length}');
    final checkIsdeposit = order.isDeposited;
    final checkIsdepositData = orderData.isDeposited;
    final checkIsPause = bookingAsync.value?.status.toUpperCase() == 'PAUSED';
    print(" check ispause $checkIsdeposit");
    // print('log care order 1 $checkIsdeposit');
    // print('log care order 2 $checkIsdepositData');
    return LoadingOverlay(
      isLoading: stateBooking.isLoading || stateOldBooking.isLoading,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Increased border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24), // Increased padding
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelText(
                  content: 'Chi tiết đơn hàng',
                  size: 16, // Increased font size
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                // You can add more widgets here if needed
              ],
            ),

            // Truck details
            ...orderData.bookingDetails
                .where((detail) => detail.type == "TRUCK")
                .map((truckDetail) {
              return buildItem(
                imageUrl: serviceData?.imageUrl ??
                    'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728489912/movemate/vs174go4uz7uw1g9js2e.jpg',
                title: truckDetail.name ?? 'Xe Tải',
                description: truckDetail.description ?? 'Không có mô tả',
              );
            }),
            Column(
              children: [
                if (order.status == 'PAUSED')
                  ServicesCardAtHome(
                    order: order,
                    orderOld: orderOld ?? order,
                  )
                else ...[
                  // Price details
                  if (order.isReviewOnline)
                    ...order.bookingDetails.map<Widget>((detail) {
                      return buildPriceItem(
                        detail.name ?? '',
                        formatPrice(detail.price.toDouble()),
                      );
                    }),

                  // Hiển thị nếu review offline
                  if (!order.isReviewOnline)
                    ServicesCardAtHome(
                      order: order,
                      orderOld: orderOld ?? order,
                    ),

                  const SizedBox(height: 12),
                ],
              ],
            ),
            const SizedBox(height: 12),
            //tiền đặt cọc
            if (order.isReviewOnline && !order.isDeposited)
              buildSummary('Tiền đặt cọc',
                  formatPrice(orderData.deposit.toDouble() ?? 0)),

            // Hiển thị các fee từ feeDetails
            if (order.isReviewOnline)
              ...orderData.feeDetails.map((fee) {
                return buildSummary(
                  fee.name,
                  formatPrice(fee.amount.toDouble()),
                );
              }),

            const Divider(
              color: Colors.grey,
              thickness: 1.5,
              height: 32,
            ),

            if (order.vouchers?.length != 0 && order.vouchers?.length != null)

              // phiếu giảm giá
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelText(
                          content: 'Phiếu giảm giá',
                          size: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  LabelText(
                    content: '- ${formatPrice((order.vouchers!.fold<double>(
                      0,
                      (total, voucher) => total + (voucher.price ?? 0),
                    )).toDouble())}',
                    size: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ],
              ),

            //tổng giá không Vouchers và là review online
            if ((order.vouchers?.length == 0 ||
                    order.vouchers?.length == null) &&
                order.isReviewOnline)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: 'Tổng giá',
                      size: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LabelText(
                      content: formatPrice((order.total).toDouble()),
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

            //Tổng giá có vouchers
            if (order.vouchers?.length != 0 && order.vouchers?.length != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: 'Tổng giá',
                      size: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LabelText(
                      content: formatPrice(((order.total) +
                              order.vouchers!.fold<double>(
                                0,
                                (total, voucher) =>
                                    total + (voucher.price ?? 0),
                              ))
                          .toDouble()),
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

            if (order.vouchers?.length != 0 && order.vouchers?.length != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: 'Tổng giá sau khi giảm',
                      size: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LabelText(
                      content: formatPrice(
                          (bookingAsync.value?.total ?? order.total)
                              .toDouble()),
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

            //sau khi deposit xong review online
            // if (bookingAsync.value?.total != bookingAsync.value?.totalReal &&
            //     order.isReviewOnline)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Padding(
            //         padding: EdgeInsets.symmetric(vertical: 6),
            //         child: LabelText(
            //           content: 'Tổng giá',
            //           size: 12,
            //           color: Colors.grey,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 6),
            //         child: LabelText(
            //           content: (bookingAsync.value?.total != 0)
            //               ? formatPrice(
            //                   bookingAsync.value?.total.toDouble() ?? 0)
            //               : '',
            //           size: 14,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),

            //tiền đặt cọc sau khi deposit
            if (order.isDeposited == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: 'Tiền đặt cọc',
                      size: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content:
                          "- ${(bookingAsync.value?.deposit != 0) ? formatPrice(bookingAsync.value?.deposit.toDouble() ?? 0) : ''}",
                      size: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

            if (bookingAsync.value?.total != bookingAsync.value?.totalReal)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: (bookingAsync.value?.totalReal != 0)
                          ? 'Tiền còn lại phải trả'
                          : 'Đã Thanh toán',
                      size: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: LabelText(
                      content: (bookingAsync.value?.totalReal != 0)
                          ? formatPrice(
                              bookingAsync.value?.totalReal.toDouble() ?? 0)
                          : '',
                      size: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    content: (order.note?.isEmpty ?? true) ? '' : 'Ghi chú',
                    size: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),
                  LabelText(
                    content: (order.note?.isEmpty ?? true) ? '' : order.note!,
                    size: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    maxLine: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Status button
            if (bookingAsync.hasValue && isActionEnabled())
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isActionEnabled() ? handleActionPress : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActionEnabled()
                        ? const Color(0xFFFF9900)
                        : Colors.grey[300],
                    elevation: isActionEnabled() ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: LabelText(
                    content: getActionButtonText(),
                    size: 16,
                    color: isActionEnabled() ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 16),
            if (checkIsPause == true)
              AcceptPause(
                order: order,
              ),
            const SizedBox(height: 16),
            // Cancel button
            if (bookingAsync.hasValue &&
                !bookingStatus.isCompleted &&
                !bookingStatus.isCancelled &&
                !order.isCancel)
              CancelButton(
                order: order,
              )
            else if (bookingAsync.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
                ),
              )
            else if (bookingAsync.hasError)
              const Center(
                child: LabelText(
                  content: 'Đã có lỗi xảy ra',
                  size: 14,
                  color: Colors.red,
                ),
              )
            else if (bookingAsync.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
                ),
              )
            else if (bookingAsync.hasError)
              const Center(
                child: LabelText(
                  content: 'Đã có lỗi xảy ra',
                  size: 14,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
