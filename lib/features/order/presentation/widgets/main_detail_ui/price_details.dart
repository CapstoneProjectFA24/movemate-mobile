import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/modal_action/reviewed_to_coming_modal.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/presentation/widgets/details/item.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';

class PriceDetails extends HookConsumerWidget {
  final OrderEntity order;
  final AsyncValue<BookingStatusType> statusAsync;

  const PriceDetails({
    super.key,
    required this.order,
    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    // Hàm hỗ trợ để định dạng giá
    String formatPrice(int price) {
      final formatter = NumberFormat('#,###', 'vi_VN');
      return '${formatter.format(price)} đ';
    }

    void handleActionPress() {
      if (bookingStatus.canMakePayment) {
        context.pushRoute(PaymentScreenRoute(id: order.id));
      } else if (bookingStatus.canReviewSuggestion) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ReviewedToComingModal(order: order),
        );
      } else if (bookingStatus.canAcceptSchedule) {
        if (order.isReviewOnline) {
          context.pushRoute(ReviewOnlineRoute(order: order));
        } else {
          context.pushRoute(ReviewAtHomeRoute(order: order));
        }
      } else if (bookingStatus.canConfirmCompletion) {
        // Add route for completion confirmation
        // context.pushRoute(CompletionConfirmationRoute(order: order));
      }
    }

    String getActionButtonText() {
      if (bookingStatus.canMakePayment) {
        return 'Thanh toán ngay';
      } else if (bookingStatus.canReviewSuggestion) {
        return 'Xem xét đề xuất';
      } else if (bookingStatus.canAcceptSchedule) {
        return 'Xác nhận lịch';
      } else if (bookingStatus.canConfirmCompletion) {
        return 'Xác nhận hoàn thành';
      }
      return '';
    }

    bool isActionEnabled() {
      return bookingStatus.canMakePayment ||
          bookingStatus.canReviewSuggestion ||
          bookingStatus.canAcceptSchedule ||
          bookingStatus.canConfirmCompletion;
    }

    return Container(
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
                content: 'Chi tiết giá',
                size: 20, // Increased font size
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              // You can add more widgets here if needed
            ],
          ),
          const SizedBox(height: 20), // Increased spacing

          // Truck details
          ...order.bookingDetails
              .where((detail) => detail.type == "TRUCK")
              .map((truckDetail) => buildItem(
                    imageUrl:
                        'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728489912/movemate/vs174go4uz7uw1g9js2e.jpg',
                    title: truckDetail.name ?? 'Xe Tải',
                    description: truckDetail.description ?? 'Không có mô tả',
                  )),

          // Price details
          ...order.bookingDetails.map<Widget>((detail) {
            return buildPriceItem(
              detail.name ?? '',
              formatPrice(detail.price.toInt()),
            );
          }),

          const SizedBox(height: 16),
          buildSummary('Tiền đặt cọc', formatPrice(order.deposit.toInt())),
          buildSummary('Tiền trả liền', formatPrice(order.totalFee.toInt())),

          const Divider(
            color: Colors.grey,
            thickness: 1.5,
            height: 32,
          ),

          if (bookingStatus.statusMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: LabelText(
                content: bookingStatus.statusMessage,
                size: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: LabelText(
                  content: 'Đặt cọc',
                  size: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: LabelText(
                  content: formatPrice(order.totalReal.toInt()),
                  size: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText(
                  content: 'Ghi chú',
                  size: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                LabelText(
                  content:
                      "${order.note!.isEmpty ? 'Không có ghi chú' : order.note}",
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
          if (bookingStatus.isReviewerMoving ||
              bookingStatus.isReviewerAssessing ||
              bookingStatus.isServicesUpdating ||
              bookingStatus.isMovingInProgress)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
              ),
            ),
        ],
      ),
    );
  }
}
