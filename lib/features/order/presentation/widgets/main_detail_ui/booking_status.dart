// components/booking_status.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';

class BookingStatus extends StatelessWidget {
  final AsyncValue<BookingStatusType> statusAsync;
  final OrderEntity order;
  const BookingStatus({
    super.key,
    required this.order,
    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: statusAsync.when(
              data: (status) => Text(
                getBookingStatusText(status).statusText,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
          ),
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
