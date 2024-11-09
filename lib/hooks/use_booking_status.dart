import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class BookingStatusResult {
  final String statusMessage;

  // Customer action states
  final bool canAcceptSchedule;
  final bool canMakePayment;
  final bool canReviewSuggestion;
  final bool canConfirmCompletion;

  // Status indicators
  final bool isWaitingSchedule;
  final bool isReviewerAssessing;
  final bool isServicesUpdating;
  final bool isSuggestionReady;
  final bool isMovingInProgress;
  final bool isCompleted;
  BookingStatusResult({
    required this.statusMessage,
    this.canAcceptSchedule = false,
    this.canMakePayment = false,
    this.canReviewSuggestion = false,
    this.canConfirmCompletion = false,
    this.isWaitingSchedule = false,
    this.isReviewerAssessing = false,
    this.isServicesUpdating = false,
    this.isSuggestionReady = false,
    this.isMovingInProgress = false,
    this.isCompleted = false,
  });
}

BookingStatusResult useBookingStatus(
    BookingRealtimeEntity? booking, bool isReviewOnline) {
  return useMemoized(() {
    if (booking == null) {
      return BookingStatusResult(statusMessage: "");
    }

    final status = booking.status.toBookingTypeEnum();
    final assignments = booking.assignments ?? [];

    // Helper functions
    bool hasAssignmentWithStatus(
        String staffType, AssignmentsStatusType status) {
      return assignments.any((a) {
        return a.staffType == staffType.toString() &&
            a.status.toAssignmentsTypeEnum() == status;
      });
    }

    // Check reviewer states
    final isReviewerAssessing =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.arrived);
    final isSuggestionReady =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.suggested);

    // Determine customer actions based on review type
    bool canAcceptSchedule = false;
    bool canMakePayment = false;
    bool canReviewSuggestion = false;
    bool canConfirmCompletion = false;
    if (isReviewOnline) {
      // Online review flow
      canMakePayment = status == BookingStatusType.reviewed;
      canReviewSuggestion = isSuggestionReady;
      canConfirmCompletion = status == BookingStatusType.completed;
    } else {
      // Offline review flow
      canAcceptSchedule = status == BookingStatusType.waiting;
      canMakePayment = status == BookingStatusType.depositing;
      canReviewSuggestion = status == BookingStatusType.reviewed;
      canConfirmCompletion = status == BookingStatusType.completed;
    }

    return BookingStatusResult(
      statusMessage: determineStatusMessage(
          status, isReviewOnline, isReviewerAssessing, isSuggestionReady),
      canAcceptSchedule: canAcceptSchedule,
      canMakePayment: canMakePayment,
      canReviewSuggestion: canReviewSuggestion,
      canConfirmCompletion: canConfirmCompletion,
      isWaitingSchedule:
          status == BookingStatusType.assigned && !isReviewOnline,
      isReviewerAssessing: isReviewerAssessing,
      isServicesUpdating:
          status == BookingStatusType.reviewing && !isSuggestionReady,
      isSuggestionReady: isSuggestionReady,
      isMovingInProgress: status == BookingStatusType.inProgress,
      isCompleted: status == BookingStatusType.completed,
    );
  }, [booking, isReviewOnline]);
}

String determineStatusMessage(
  BookingStatusType status,
  bool isReviewOnline,
  bool isReviewerAssessing,
  bool isSuggestionReady,
) {
  if (isReviewOnline) {
    switch (status) {
      case BookingStatusType.assigned:
        return "Nhân viên đang xem xét yêu cầu của bạn";
      case BookingStatusType.reviewing:
        if (isSuggestionReady) return "Đã có đề xuất dịch vụ mới";
        return "Đang trong quá trình đánh giá trực tuyến";
      case BookingStatusType.reviewed:
        return "Vui lòng thanh toán để tiến hành dịch vụ";
      case BookingStatusType.depositing:
        return "Đang xử lý thanh toán";
      case BookingStatusType.coming:
        return "Đội ngũ vận chuyển đang trên đường đến";
      case BookingStatusType.inProgress:
        return "Đang thực hiện vận chuyển";
      case BookingStatusType.completed:
        return "Dịch vụ đã hoàn thành";
      case BookingStatusType.cancelled:
        return "Đơn hàng đã bị hủy";
      case BookingStatusType.refunded:
        return "Đã hoàn tiền";
      case BookingStatusType.pending:
        return "Đang xử lý yêu cầu";
      default:
        return "Không xác định";
    }
  } else {
    switch (status) {
      case BookingStatusType.assigned:
        return "Đang chờ lịch khảo sát";
      case BookingStatusType.waiting:
        return "Vui lòng xác nhận lịch khảo sát";
      case BookingStatusType.depositing:
        return "Vui lòng thanh toán đặt cọc";
      case BookingStatusType.reviewing:
        if (isReviewerAssessing) return "Nhân viên đang khảo sát nhà của bạn";
        if (isSuggestionReady) return "Đã có đề xuất dịch vụ mới";
        return "Đang trong quá trình khảo sát";
      case BookingStatusType.reviewed:
        return "Vui lòng xem xét đề xuất dịch vụ";
      case BookingStatusType.coming:
        return "Đội ngũ vận chuyển đang trên đường đến";
      case BookingStatusType.inProgress:
        return "Đang thực hiện vận chuyển";
      case BookingStatusType.completed:
        return "Dịch vụ đã hoàn thành";
      case BookingStatusType.cancelled:
        return "Đơn hàng đã bị hủy";
      case BookingStatusType.refunded:
        return "Đã hoàn tiền";
      case BookingStatusType.pending:
        return "Đang xử lý";
      default:
        return "Không xác định";
    }
  }
}
