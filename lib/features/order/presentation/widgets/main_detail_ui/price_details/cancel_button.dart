import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/cancel_diaglog.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class CancelButton extends HookConsumerWidget {
  final OrderEntity order;

  const CancelButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    bool isCancelEnabled() {
      return bookingStatus.canCanceled;
    }

    bool isCancelText() {
      return bookingStatus.isCancelled;
    }

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: (isCancelEnabled())
            ? () {
                showCancelDialogPreDeposit(context, ref);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isCancelEnabled() ? Colors.orange : Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: LabelText(
          content: 'Hủy đơn hàng',
          size: 14,
          color: isCancelEnabled() ? Colors.orange : Colors.grey[600]!,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showCancelDialogPreDeposit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      // barrierColor: Colors.grey.shade100.withOpacity(0.5),
      builder: (BuildContext context) {
        String? selectedReason;

        return StatefulBuilder(
          builder: (context, setState) {
            return CancelDialog(
              onReasonSelected: (reason) {
                selectedReason = reason;
              },
              onCancelPressed: () async {
                if (selectedReason != null) {
                  final cancelRequest = CancelBooking(
                    id: order.id,
                    cancelReason: selectedReason!,
                  );

                  await ref
                      .read(bookingControllerProvider.notifier)
                      .cancelBooking(
                        request: cancelRequest,
                        id: order.id,
                        context: context,
                      );
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }

  void showCancelDialogPostDeposit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      // barrierColor: Colors.grey.shade100.withOpacity(0.5),
      builder: (BuildContext context) {
        String? selectedReason;

        return StatefulBuilder(
          builder: (context, setState) {
            return CancelDialog(
              onReasonSelected: (reason) {
                selectedReason = reason;
              },
              onCancelPressed: () async {
                if (selectedReason != null) {
                  final cancelRequest = CancelBooking(
                    id: order.id,
                    cancelReason: selectedReason!,
                  );

                  await ref
                      .read(bookingControllerProvider.notifier)
                      .cancelBooking(
                        request: cancelRequest,
                        id: order.id,
                        context: context,
                      );
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }
}
