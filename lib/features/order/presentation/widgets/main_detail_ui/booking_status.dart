import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

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

    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCancelled
                ? [
                    Colors.blueGrey.shade400,
                    Colors.grey.shade600,
                  ]
                : isComplete
                    ? [
                        Colors.green.shade400,
                        Colors.green.shade600,
                      ]
                    : !insTructionIconFolowStatus
                        ? [Colors.blueAccent.withOpacity(0.2), Colors.white]
                        : [Colors.orangeAccent.withOpacity(0.5), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  // Icon(
                  //   isCancelled
                  //       ? Icons.cancel
                  //       : isComplete
                  //           ? Icons.check_circle
                  //           : Icons.info_outline,
                  //   color: isCancelled
                  //       ? Colors.red
                  //       : isComplete
                  //           ? AssetsConstants.green6
                  //           : !insTructionIconFolowStatus
                  //               ? Colors.blue.shade500
                  //               : Colors.red.shade400,
                  //   size: 20,
                  // ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LabelText(
                      content: bookingStatus.statusMessage,
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: isCancelled ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Text(
                "MoveMate sẽ gửi thông tin đến bạn sau",
                style: TextStyle(
                  fontSize: 12,
                  color: isCancelled ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
