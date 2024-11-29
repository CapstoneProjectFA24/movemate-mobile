import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/modal_action/reviewed_to_coming_modal.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
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
  // final List<ServicesPackageEntity> serviceAll;
  final ServicesPackageEntity? serviceData;
  const PriceDetails({
    super.key,
    required this.order,
    //  required this.serviceAll, // thêm dữ liệu serviceAll vào để lấy thông tin service tương ứng
    required this.serviceData,
    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    String formatPrice(int price) {
      final formatter = NumberFormat('#,###', 'vi_VN');
      return '${formatter.format(price)} đ';
    }

    final stateBooking = ref.watch(bookingControllerProvider);
    final stateOldBooking = ref.watch(orderControllerProvider);
    final currentprice =
        ref.watch(bookingStreamProvider(order.id.toString())).value;

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
    final orderOld = useFetcholdOrder.data as OrderEntity;

    final orderObj = orderEntity.data;

    useEffect(() {
      orderEntity.refresh();
      return null;
    }, [bookingAsync.value?.totalReal]);

    useEffect(() {
      return null;
    }, [bookingStatus.canReviewSuggestion]);

    print("check data 1${orderObj?.bookingDetails.length}");
    print("check data 2${orderOld.bookingDetails.length}");
// Kiểm tra điều kiện và gán giá trị cho biến orderData
    // final orderData = bookingStatus.canReviewSuggestion ? orderObj : orderOld;
    final orderData = bookingStatus.canReviewSuggestion ? orderObj : orderOld;

    print("check data 3 ${orderData?.bookingDetails.length}");

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
          context.pushRoute(PaymentScreenRoute(id: order.id));
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
        } else if (bookingStatus.canMakePayment) {
          context.pushRoute(PaymentScreenRoute(id: order.id));
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
          return 'Thanh toán ngay';
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
          return 'Thanh toán ngay';
        } else if (bookingStatus.canMakePaymentLast) {
          return 'Xác nhận thanh toán';
        }
      }
      return '';
    }

    bool isCancelEnabled() {
      return bookingStatus.canReviewSuggestion ||
          bookingStatus.canAcceptSchedule ||
          bookingStatus.isWaitingStaffSchedule ||
          bookingStatus.isProcessingRequest ||
          bookingStatus.isOnlineReviewing ||
          bookingStatus.isOnlineSuggestionReady ||
          bookingStatus.canMakePayment;
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

    return LoadingOverlay(
      isLoading: stateBooking.isLoading && stateOldBooking.isLoading,
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

            // Price details
            ...orderData.bookingDetails.map<Widget>((detail) {
              return buildPriceItem(
                detail.name ?? '',
                formatPrice(detail.price.toInt()),
              );
            }),

            const SizedBox(height: 12),
            buildSummary(
                'Tiền đặt cọc', formatPrice(orderData.deposit.toInt() ?? 0)),
            // Hiển thị các fee từ feeDetails
            ...orderData.feeDetails.map((fee) {
              return buildSummary(
                fee.name,
                formatPrice(fee.amount.toInt()),
              );
            }),

            const Divider(
              color: Colors.grey,
              thickness: 1.5,
              height: 32,
            ),

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
                    content: formatPrice(orderData.total.toInt() ?? 0),
                    size: 18,
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

            // Cancel button
            if (bookingAsync.hasValue &&
                !bookingStatus.isCompleted &&
                !bookingStatus.isCancelled)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isCancelEnabled()
                      ? () {
                          // Handle cancel action
                          showDialog(
                            context: context,
                            // barrierColor: Colors.grey.shade100.withOpacity(0.5),
                            builder: (BuildContext context) {
                              String? selectedReason;

                              print('Selected Reason: $selectedReason');
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const LabelText(
                                      size: 16,
                                      content:
                                          'Vui lòng chọn lý do hủy đơn hàng',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const LabelText(
                                          size: 12,
                                          color: Colors.grey,
                                          content:
                                              'Lưu ý: Thao tác này sẽ hủy tất cả dịch vụ có trong đơn hàng và không thể hoàn tác.',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              title: const LabelText(
                                                size: 12,
                                                content:
                                                    'Muốn thay đổi dịch vụ trong đơn hàng',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              leading: Radio<String>(
                                                value:
                                                    'Muốn thay đổi dịch vụ trong đơn hàng',
                                                groupValue: selectedReason,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedReason = value;
                                                  });
                                                },
                                                activeColor: Colors
                                                    .orange, // Change color when selected
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              title: const LabelText(
                                                size: 12,
                                                content:
                                                    'Thủ tục thanh toán quá rắc rối',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              leading: Radio<String>(
                                                value:
                                                    'Thủ tục thanh toán quá rắc rối',
                                                groupValue: selectedReason,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedReason = value;
                                                  });
                                                },
                                                activeColor: Colors
                                                    .orange, // Change color when selected
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              title: const LabelText(
                                                size: 12,
                                                content:
                                                    'Tìm thấy giá rẻ hơn ở chỗ khác',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              leading: Radio<String>(
                                                value:
                                                    'Tìm thấy giá rẻ hơn ở chỗ khác',
                                                groupValue: selectedReason,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedReason = value;
                                                  });
                                                },
                                                activeColor: Colors
                                                    .orange, // Change color when selected
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              title: const LabelText(
                                                size: 12,
                                                content:
                                                    'Đổi ý không muốn đặt dịch vụ nữa',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              leading: Radio<String>(
                                                value:
                                                    'Đổi ý không muốn đặt dịch vụ nữa',
                                                groupValue: selectedReason,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedReason = value;
                                                  });
                                                },
                                                activeColor: Colors
                                                    .orange, // Change color when selected
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              title: const LabelText(
                                                size: 12,
                                                content: 'Lý do khác',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              leading: Radio<String>(
                                                value: 'Lý do khác',
                                                groupValue: selectedReason,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedReason = value;
                                                  });
                                                },
                                                activeColor: Colors
                                                    .orange, // Change color when selected
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const LabelText(
                                          size: 14,
                                          content: 'Hủy',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: selectedReason != null
                                            ? () async {
                                                // Perform cancel logic here with `selectedReason`
                                                final cancelRequest =
                                                    CancelBooking(
                                                  id: order.id,
                                                  cancelReason:
                                                      selectedReason ??
                                                          "String",
                                                );
                                                print(
                                                    'Selected Reason: $selectedReason');

                                                await ref
                                                    .read(
                                                        bookingControllerProvider
                                                            .notifier)
                                                    .cancelBooking(
                                                      request: cancelRequest,
                                                      id: order.id,
                                                      context: context,
                                                    );
                                                Navigator.pop(context);
                                              }
                                            : null, // Disable button if no reason is selected
                                        child: const LabelText(
                                          size: 14,
                                          content: 'Xác nhận',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      : () {
                          // Show dialog when cancel is not enabled
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.grey.shade100,
                              content: const Text(
                                'Rất tiếc bạn không thể hủy đơn hàng lúc này. Vui lòng liên hệ bộ phận Chăm sóc Khách hàng nếu cần hỗ trợ.',
                                style: TextStyle(fontSize: 14),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const LabelText(
                                    content: 'OK',
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    launch('tel:0382703625');
                                  },
                                  child: const LabelText(
                                    content: 'Hỗ trợ',
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isCancelEnabled()
                            ? Colors.orange
                            : Colors.grey[300]!, // Correct color handling
                        width:
                            1, // Uniform width, as it's the same for both conditions
                      ),
                    ),
                  ),
                  child: LabelText(
                    content: 'Hủy đơn hàng',
                    size: 14,
                    color: isCancelEnabled()
                        ? Colors.orange
                        : Colors.grey[
                            600], // Color dynamically changes based on state
                    fontWeight: FontWeight.bold,
                  ),
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

            // Show progress indicators if needed
            // if (bookingStatus.isReviewerMoving ||
            //     bookingStatus.isReviewerAssessing ||
            //     bookingStatus.isSuggestionReady ||
            //     bookingStatus.isMovingInProgress)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 16),
            //     child: LinearProgressIndicator(
            //       backgroundColor: Colors.grey[200],
            //       valueColor:
            //           const AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
