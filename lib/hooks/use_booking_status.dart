import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_bottom_sheet.dart';
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
  final bool isReviewerMoving;
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
    this.isReviewerMoving = false,
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
        print(
            'Current assignment - staffType: ${a.staffType}, status: ${a.status}');
        return a.staffType == staffType.toString() &&
            a.status.toAssignmentsTypeEnum() == status;
      });
    }

    // Check reviewer states

    final isReviewerMoving =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.incoming);

    final isReviewerAssessing =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.arrived);
    final isSuggestionReady =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.suggested);

    // => phân rõ là trong quá trình đó user có action hay ko
    // => case: 1 có action thì tạo trạng thái action
    // => case: 2 ko action thì chỉ tạo trạng chờ để seen
    // Determine customer actions based on review type
    bool canAcceptSchedule = false;
    bool canMakePayment = false;
    bool canReviewSuggestion = false;
    bool canConfirmCompletion = false;
    if (isReviewOnline) {
      // Online review flow
      canMakePayment = status == BookingStatusType.depositing;
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
        status,
        isReviewOnline,
        isReviewerMoving,
        isReviewerAssessing,
        isSuggestionReady,
      ),
      canAcceptSchedule: canAcceptSchedule,
      canMakePayment: canMakePayment,
      canReviewSuggestion: canReviewSuggestion,
      canConfirmCompletion: canConfirmCompletion,
      isWaitingSchedule:
          status == BookingStatusType.assigned && !isReviewOnline,
      isReviewerAssessing: isReviewerAssessing,
      isReviewerMoving: isReviewerMoving,
      isServicesUpdating:
          status == BookingStatusType.reviewing && !isSuggestionReady,
      isSuggestionReady: isSuggestionReady,
      isMovingInProgress: status == BookingStatusType.coming,
      isCompleted: status == BookingStatusType.completed,
    );
  }, [booking, isReviewOnline]);
}

String determineStatusMessage(
  BookingStatusType status,
  bool isReviewOnline,
  bool isReviewerMoving,
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
        return "Đang chờ bạn thanh toán";
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
        if (isReviewerMoving) return "Nhân viên đang trong quá trình di chuyển";
        if (isReviewerAssessing) return "Nhân viên đang khảo sát nhà của bạn";
        if (isSuggestionReady) return "Đã có đề xuất dịch vụ mới";
        return "Chờ nhân viên tới khảo sát";
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
        return "Đang xử lý yêu cầu";
      default:
        return "Không xác định";
    }
  }
}
