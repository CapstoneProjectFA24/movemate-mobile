import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';

class BookingStatus extends HookConsumerWidget {
  final OrderEntity order;

  const BookingStatus({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    final isCancelled = bookingStatus.isCancelled;
    final insTructionIconFolowStatus = bookingStatus.canMakePayment ||
        bookingStatus.canAcceptSchedule ||
        bookingStatus.canReviewSuggestion;

    final isComplete = bookingStatus.isCompleted;
    final isRefunding = bookingStatus.isRefunding;

    String statusText;
    String statusTextDetails = bookingStatus.statusMessage;

    if (isComplete) {
      if (order.isRefunded) {
        statusText = 'Đã hoàn tiền';
        statusTextDetails = 'Đã hoàn lại tiền vào ví của bạn';
      } else if (isComplete) {
        statusText = 'Đã hủy';
        statusTextDetails = 'Đơn hàng đã bị hủy';
      } else {
        statusText = 'Hoàn thành';
        statusTextDetails = 'bookingStatus.statusMessage';
      }
    } else if (isRefunding) {
      statusText = 'Đang chờ hoàn tiền';
      statusTextDetails =
          'Chúng tôi đang xử lý yêu cầu hoàn tiền cho đơn hàng này';
    } else if (isCancelled) {
      statusText = 'Đã hủy';
      statusTextDetails = 'Đơn hàng đã bị hủy';
    } else if (!insTructionIconFolowStatus) {
      statusText = 'Đang chờ thực hiện';
    } else {
      statusText = 'Đang thực hiện';
      statusTextDetails = bookingStatus.statusMessage;
    }

    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              content: statusText,
              size: 16,
              fontWeight: FontWeight.w600,
            ),
            if (bookingStatus.statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: LabelText(
                  content: statusTextDetails,
                  size: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (isComplete)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Nếu cần hỗ trợ thêm, bạn vui lòng truy cập Trung tâm trợ giúp',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
