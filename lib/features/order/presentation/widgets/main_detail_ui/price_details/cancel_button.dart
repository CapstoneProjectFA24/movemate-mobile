import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/cancel_diaglog.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/post_deposit_cancel_dialog.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:url_launcher/url_launcher.dart';

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
        useBookingStatus(bookingAsync.value, order.isReviewOnline ?? false);

    bool isCancelEnabled() {
      return bookingStatus.canCanceled;
    }

    // Xác định các điều kiện cụ thể
    final bool canCancelPreDeposit = bookingStatus.canCanceledPreDeposit;
    final bool canCancelPostDeposit = bookingStatus.canCanceledPostDeposit;
    final bool enabled = (canCancelPreDeposit || canCancelPostDeposit);

    void handleCancel() {
      if (canCancelPreDeposit) {
        showCancelDialogPreDeposit(context, ref);
      } else if (canCancelPostDeposit) {
        showCancelDialogPostDeposit(context, ref);
      }
    }

    void handleDisabled() {
      showCancelDiaglogWhenDisableButton(context, ref);
    }

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: enabled ? handleCancel : handleDisabled,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: enabled ? Colors.orange : Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: LabelText(
          content: 'Hủy đơn hàng',
          size: 14,
          color: enabled ? Colors.orange : Colors.grey[600]!,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showCancelDialogPreDeposit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
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

  /// Hiển thị dialog cảnh báo trước khi hủy sau khi đặt cọc

  void showCancelDialogPostDeposit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PostDepositCancelDialog(
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: () async {
            // Thực hiện logic hủy đơn ở đây
            // Ví dụ:
            // await ref.read(bookingControllerProvider.notifier)
            //   .cancelBooking(request: cancelRequest, id: order.id, context: context);
            context.router.push(RefundScreenRoute(order: order));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Hàm mới để hiển thị CancelDialog sau khi xác nhận từ dialog cảnh báo
  void showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
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
                  Navigator.pop(context); // Đóng CancelDialog
                }
              },
            );
          },
        );
      },
    );
  }

  void showCancelDiaglogWhenDisableButton(BuildContext context, WidgetRef ref) {
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
  }
}
