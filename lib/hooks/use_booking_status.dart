import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class BookingStatusResult {
  final String statusMessage;

  // Customer action states
  final bool canAcceptSchedule; // Xác nhận lịch khảo sát (offline only)
  final bool canMakePayment; // Thanh toán
  final bool canReviewSuggestion; // Xác nhận đánh giá của reviewer

  // Status indicators - Offline Flow
  final bool
      isWaitingStaffSchedule; // Đợi staff xếp lịch (assigned + REVIEWER/assigned)
  final bool
      isReviewerMoving; // Reviewer đang di chuyển (reviewing + REVIEWER/incoming)
  final bool
      isReviewerAssessing; // Reviewer đang khảo sát (reviewing + REVIEWER/arrived)
  final bool
      isSuggestionReady; // Có đề xuất mới (reviewing + REVIEWER/suggested)

  // Status indicators - Online Flow
  final bool
      isProcessingRequest; // Xử lý yêu cầu (assigned + REVIEWER/assigned)
  final bool
      isOnlineReviewing; // Đang đánh giá online (reviewing + REVIEWER/assigned)
  final bool
      isOnlineSuggestionReady; // Có đề xuất mới online (reviewing + REVIEWER/suggested)

  // Status indicators - Driver Flow
  final bool isDriverProcessingMoving;

  // Status indicator - Porter Flow
  final bool isPorterProcessingMoving;

  // Common indicators
  final bool isMovingInProgress; // Đang vận chuyển (coming)
  final bool isCompleted; // Hoàn thành
  final bool isCancelled; // Đã hủy
  final bool isRefunded; // Đã hoàn tiền

  BookingStatusResult({
    required this.statusMessage,
    this.canAcceptSchedule = false,
    this.canMakePayment = false,
    this.canReviewSuggestion = false,
    this.isWaitingStaffSchedule = false,
    this.isReviewerMoving = false,
    this.isReviewerAssessing = false,
    this.isSuggestionReady = false,
    this.isProcessingRequest = false,
    this.isOnlineReviewing = false,
    this.isOnlineSuggestionReady = false,
    this.isMovingInProgress = false,
    this.isDriverProcessingMoving = false,
    this.isPorterProcessingMoving = false,
    this.isCompleted = false,
    this.isCancelled = false,
    this.isRefunded = false,
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

    // Helper function to check assignment status
    bool hasAssignmentWithStatus(
        String staffType, AssignmentsStatusType subStatus) {
      return assignments.any((a) =>
          a.staffType == staffType &&
          a.status.toAssignmentsTypeEnum() == subStatus);
    }

    // Check reviewer states
    final hasReviewerAssigned =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.assigned);
    final isReviewerMoving =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.incoming);
    final isReviewerAssessing =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.arrived);
    final isSuggestionReady =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.suggested);

    // Initialize action and state flags
    bool canAcceptSchedule = false;
    bool canMakePayment = false;
    bool canReviewSuggestion = false;
    bool isWaitingStaffSchedule = false;
    bool isProcessingRequest = false;
    bool isOnlineReviewing = false;
    bool isOnlineSuggestionReady = false;

    if (isReviewOnline) {
      // Online flow
      switch (status) {
        case BookingStatusType.assigned:
          if (hasReviewerAssigned) {
            isProcessingRequest = true;
          }
          break;
        case BookingStatusType.reviewing:
          if (hasReviewerAssigned) {
            isOnlineReviewing = true;
          }
          if (isSuggestionReady) {
            isOnlineSuggestionReady = true;
          }
          break;
        case BookingStatusType.reviewed:
          canReviewSuggestion = true;
          break;
        case BookingStatusType.depositing:
          canMakePayment = true;
          break;
        default:
          break;
      }
    } else {
      // Offline flow
      switch (status) {
        case BookingStatusType.assigned:
          if (hasReviewerAssigned) {
            isWaitingStaffSchedule = true;
          }
          break;
        case BookingStatusType.waiting:
          canAcceptSchedule = true;
          break;
        case BookingStatusType.depositing:
          canMakePayment = true;
          break;
        case BookingStatusType.reviewing:
          if (isReviewerMoving) {
            // Reviewer đang di chuyển
          } else if (isReviewerAssessing) {
            // Reviewer đang khảo sát
          } else if (isSuggestionReady) {
            // Có đề xuất mới
          }
          break;
        case BookingStatusType.reviewed:
          canReviewSuggestion = true;
          break;
        default:
          break;
      }
    }

    // Check driver state
    final isDriverIncoming =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.incoming);

    final isDriverInProgress =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.inProgress);

    // flag to check driver state
    bool isDriverProcessingMoving = false;
    switch (status) {
      case BookingStatusType.coming:
        if (isDriverInProgress || isDriverIncoming) {
          isDriverProcessingMoving = true;
        }
        break;
      case BookingStatusType.inProgress:
        if (isDriverInProgress || isDriverIncoming) {
          isDriverProcessingMoving = true;
        }
        break;
      default:
        break;
    }

    // check porter state
    final isPorterIncoming =
        hasAssignmentWithStatus("PORTER", AssignmentsStatusType.incoming);

    final isPorterInProgress =
        hasAssignmentWithStatus("PORTER", AssignmentsStatusType.inProgress);

    // flag to check driver state
    bool isPorterProcessingMoving = false;
    switch (status) {
      case BookingStatusType.coming:
        if (isPorterIncoming || isPorterInProgress) {
          isPorterProcessingMoving = true;
        }
        break;
      case BookingStatusType.inProgress:
        if (isPorterIncoming || isPorterInProgress) {
          isPorterProcessingMoving = true;
        }
        break;
      default:
        break;
    }

    return BookingStatusResult(
      statusMessage: determineStatusMessage(
        status,
        isReviewOnline,
        isReviewerMoving,
        isReviewerAssessing,
        isSuggestionReady,
      ),
      // Customer actions
      canAcceptSchedule: canAcceptSchedule,
      canMakePayment: canMakePayment,
      canReviewSuggestion: canReviewSuggestion,

      // Offline flow states
      isWaitingStaffSchedule: isWaitingStaffSchedule,
      isReviewerMoving: isReviewerMoving,
      isReviewerAssessing: isReviewerAssessing,
      isSuggestionReady: isSuggestionReady,

      // Online flow states
      isProcessingRequest: isProcessingRequest,
      isOnlineReviewing: isOnlineReviewing,
      isOnlineSuggestionReady: isOnlineSuggestionReady,

      // Driver and Porter states
      isDriverProcessingMoving: isDriverProcessingMoving,
      isPorterProcessingMoving: isPorterProcessingMoving,

      // Common states
      isMovingInProgress: status == BookingStatusType.coming,
      isCompleted: status == BookingStatusType.completed,
      isCancelled: status == BookingStatusType.cancelled,
      isRefunded: status == BookingStatusType.refunded,
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
        return "Vui lòng xác nhận đề xuất dịch vụ";
      case BookingStatusType.depositing:
        return "Vui lòng thanh toán để tiến hành dịch vụ";
      case BookingStatusType.coming:
        return "Đội ngũ vận chuyển đang trên đường đến";

      default:
        return _getDefaultStatusMessage(status);
    }
  } else {
    switch (status) {
      case BookingStatusType.assigned:
        return "Đang chờ nhân viên xếp lịch khảo sát";
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
        return "Vui lòng xác nhận đề xuất dịch vụ";
      case BookingStatusType.coming:
        return "Đội ngũ vận chuyển đang trên đường đến";

      default:
        return _getDefaultStatusMessage(status);
    }
  }
}

String _getDefaultStatusMessage(BookingStatusType status) {
  switch (status) {
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
