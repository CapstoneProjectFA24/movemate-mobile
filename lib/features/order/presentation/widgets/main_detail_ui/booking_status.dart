// components/booking_status.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';

class BookingStatus extends HookConsumerWidget {
  final OrderEntity order;
  const BookingStatus({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);
    return Column(
      children: [
        FadeInUp(
          child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: LabelText(
                content: bookingStatus.statusMessage,
                size: 20,
                fontWeight: FontWeight.w500,
              )),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: FadeInUp(
            child: const Text(
              "MoveMate sẽ gửi thông tin đến bạn sau",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
