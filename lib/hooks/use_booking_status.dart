import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class BookingStatusResult {
  final String statusMessage;

  // Customer action states
  final bool canAcceptSchedule; // Xác nhận lịch khảo sát (offline only)
  final bool canMakePayment; // Thanh toán
  final bool canMakePaymentLast; // Thanh toán
  final bool canReviewSuggestion; // Xác nhận đánh giá của reviewer
  final bool canCanceled; // Có thể hủy
  final bool canCanceledPreDeposit; // Có thể hủy
  final bool canCanceledPostDeposit; // Có thể hủy
  final bool canReport; // Có thể báo cáo sự cố

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
  final bool isStaffDriverComingToBuildRoute;
  final bool isDriverInProgressToBuildRoute;

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
    this.canMakePaymentLast = false,
    this.canReviewSuggestion = false,
    this.canCanceled = false,
    this.canCanceledPreDeposit = false,
    this.canCanceledPostDeposit = false,
    this.canReport = false,
    this.isWaitingStaffSchedule = false,
    this.isReviewerMoving = false,
    this.isReviewerAssessing = false,
    this.isSuggestionReady = false,
    this.isProcessingRequest = false,
    this.isOnlineReviewing = false,
    this.isOnlineSuggestionReady = false,
    this.isMovingInProgress = false,
    this.isDriverProcessingMoving = false,
    this.isStaffDriverComingToBuildRoute = false,
    this.isDriverInProgressToBuildRoute = false,
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

    // Helper function to check assignment has in booking
    bool hasAssignmentInbooking(String staffType) {
      return assignments.any((a) => a.staffType == staffType);
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
// check driver complete
    final isDriverCompleted =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.completed);
//check porter complete
    final isPorterCompleted =
        hasAssignmentWithStatus("PORTER", AssignmentsStatusType.completed);

    // Check driver state

    final isDriverWaiting =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.waiting);
    final isDriverAssigned =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.assigned);
    final isDriverIncoming =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.incoming);
    final isDriverArrived =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.arrived);
    final isDriverInProgress =
        hasAssignmentWithStatus("DRIVER", AssignmentsStatusType.inProgress);
    //check porter has booking
    final isDriverHasBooking = hasAssignmentInbooking("DRIVER");
    final isPorterHasBooking = hasAssignmentInbooking("PORTER");
    final isPorterAssigned =
        hasAssignmentWithStatus("PORTER", AssignmentsStatusType.assigned);
    // Initialize action and state flags
    bool canAcceptSchedule = false;
    bool canMakePayment = false;
    bool canMakePaymentLast = false;
    bool canReviewSuggestion = false;
    bool canCanceled = false;
    bool canCanceledPreDeposit = false;
    bool canCanceledPostDeposit = false;
    bool canReport = false;

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
            canCanceled = true;
            canCanceledPreDeposit = true;
          }
          break;
        case BookingStatusType.reviewing:
          if (hasReviewerAssigned) {
            isOnlineReviewing = true;
            canCanceled = true;
            canCanceledPreDeposit = true;
          }
          if (isSuggestionReady) {
            isOnlineSuggestionReady = true;
            canCanceled = true;
            canCanceledPreDeposit = true;
          }
          break;
        case BookingStatusType.reviewed:
          canReviewSuggestion = true;
          canCanceled = true;
          canCanceledPreDeposit = true;
          break;
        case BookingStatusType.depositing:
          canMakePayment = true;
          canCanceled = true;
          canCanceledPreDeposit = true;
          break;
        case BookingStatusType.coming:
          canCanceled = true;
          // canCanceledPostDeposit = true;

          if (isDriverAssigned && isPorterHasBooking) {
            if (isPorterAssigned) {
              canCanceledPostDeposit = true;
            } else {
              canCanceledPostDeposit = false;
            }
          } else if (isDriverAssigned && !isPorterHasBooking) {
            if (isDriverAssigned) {
              canCanceledPostDeposit = true;
            } else {
              canCanceledPostDeposit = false;
            }
          } else {
            canCanceledPostDeposit = true;
          }

          break;
        case BookingStatusType.inProgress:
          canReport = true;
          canCanceled = false;
          canCanceledPreDeposit = false;
          canCanceledPostDeposit = false;

          if (isDriverCompleted && isPorterHasBooking) {
            if (isPorterCompleted) {
              canMakePaymentLast = true;
            } else {
              canMakePaymentLast = false;
            }
          } else if (isDriverCompleted && !isPorterHasBooking) {
            canMakePaymentLast = true;
          }

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
            canCanceled = true;
            canCanceledPreDeposit = true;
          }
          break;
        case BookingStatusType.waiting:
          canAcceptSchedule = true;
          canCanceled = true;
          canCanceledPreDeposit = true;
          break;
        case BookingStatusType.depositing:
          canMakePayment = true;
          canCanceled = true;
          canCanceledPreDeposit = true;
          break;

        case BookingStatusType.reviewing:
          if (hasReviewerAssigned) {
            canCanceled = true;
            canCanceledPostDeposit = true;
          } else if (isReviewerMoving) {
            canCanceled = true;
            canCanceledPostDeposit = true;
            // Reviewer đang di chuyển
          } else if (isReviewerAssessing) {
            canCanceled = true;
            canCanceledPostDeposit = true;
            // Reviewer đang khảo sát
          } else if (isSuggestionReady) {
            canCanceled = true;
            canCanceledPostDeposit = true;
            // Có đề xuất mới
          }
          break;
        case BookingStatusType.reviewed:
          canReviewSuggestion = true;
          canCanceled = true;
          canCanceledPostDeposit = true;
          break;
        case BookingStatusType.coming:
          canCanceled = true;
          // canCanceledPostDeposit = true;
          if (isDriverAssigned && isPorterHasBooking) {
            if (isPorterAssigned) {
              canCanceledPostDeposit = true;
            } else {
              canCanceledPostDeposit = false;
            }
          } else if (isDriverAssigned && !isPorterHasBooking) {
            if (isDriverAssigned) {
              canCanceledPostDeposit = true;
            } else {
              canCanceledPostDeposit = false;
            }
          } else {
            canCanceledPostDeposit = true;
          }

          break;

        case BookingStatusType.inProgress:
          canReport = true;
          if (isDriverCompleted && isPorterHasBooking) {
            if (isPorterCompleted) {
              canMakePaymentLast = true;
            } else {
              canMakePaymentLast = false;
            }
          } else if (isDriverCompleted && !isPorterHasBooking) {
            canMakePaymentLast = true;
          }
          canCanceledPreDeposit = false;
          canCanceledPostDeposit = false;
          canCanceled = false;

        default:
          break;
      }
    }

    // flag to check driver state
    bool isDriverProcessingMoving = false;
    bool isStaffDriverComingToBuildRoute = false;
    bool isDriverInProgressToBuildRoute = false;
    switch (status) {
      case BookingStatusType.coming:
        if (isDriverInProgress ||
            isDriverIncoming ||
            isDriverArrived ||
            isDriverAssigned ||
            isDriverCompleted) {
          isDriverProcessingMoving = true;
        }
        if (isDriverWaiting ||
            isDriverAssigned ||
            isDriverIncoming ||
            (!isDriverInProgress && !isDriverCompleted && !isDriverArrived)) {
          isStaffDriverComingToBuildRoute = true;
        }
        // isStaffDriverComingToBuildRoute = isDriverWaiting ||
        //     isDriverAssigned ||
        //     isDriverIncoming ||
        //     (!isDriverInProgress && !isDriverCompleted && !isDriverArrived);
        break;
      case BookingStatusType.inProgress:
        if (isDriverInProgress ||
            isDriverIncoming ||
            isDriverArrived ||
            isDriverAssigned ||
            isDriverCompleted) {
          isDriverProcessingMoving = true;
        }
        if (isDriverWaiting ||
            isDriverAssigned ||
            isDriverIncoming ||
            (!isDriverInProgress && !isDriverCompleted && !isDriverArrived)) {
          isStaffDriverComingToBuildRoute = true;
        }
        // isStaffDriverComingToBuildRoute = ;

        isDriverInProgressToBuildRoute = isDriverArrived || isDriverInProgress;
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
      canMakePaymentLast: canMakePaymentLast,
      canReviewSuggestion: canReviewSuggestion,
      canCanceled: canCanceled,
      canCanceledPreDeposit: canCanceledPreDeposit,
      canCanceledPostDeposit: canCanceledPostDeposit,
      canReport: canReport,

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
      isStaffDriverComingToBuildRoute: isStaffDriverComingToBuildRoute,
      isDriverInProgressToBuildRoute: isDriverInProgressToBuildRoute,
      // isDriverCompleted: isDriverCompleted,
      // isPorterCompleted: isPorterCompleted,
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
