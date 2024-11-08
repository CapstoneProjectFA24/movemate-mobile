import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/services/map_services/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class BookingStatusResult {
  final String statusMessage;

  // Reviewer states
  final bool canReviewOffline;
  final bool canReviewOnline;
  final bool canCreateSchedule;
  final bool canConfirmReview;
  final bool canUpdateServices;
  final bool canConfirmArrival;
  final bool canConfirmMoving;
  final bool canConfirmSuggestion;

  // Status indicators
  final bool isWaitingCustomer;
  final bool isWaitingPayment;
  final bool isStaffEnroute;
  final bool isStaffArrived;
  final bool isSuggested;
  final bool isReviewed;

  // Driver/Porter states
  final bool isInProgress;
  final bool isCompleted;

  BookingStatusResult({
    required this.statusMessage,
    this.canReviewOffline = false,
    this.canReviewOnline = false,
    this.canCreateSchedule = false,
    this.canConfirmReview = false,
    this.canUpdateServices = false,
    this.canConfirmArrival = false,
    this.canConfirmMoving = false,
    this.canConfirmSuggestion = false,
    this.isWaitingCustomer = false,
    this.isWaitingPayment = false,
    this.isStaffEnroute = false,
    this.isStaffArrived = false,
    this.isSuggested = false,
    this.isReviewed = false,
    this.isInProgress = false,
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

    // Xác định reviewer assignment
    final hasReviewerAssignment =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.assigned);

    // Trạng thái của assignments
    final isStaffEnroute =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.enroute);

    final isStaffArrived =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.arrived);

    final isSuggested =
        hasAssignmentWithStatus("REVIEWER", AssignmentsStatusType.suggested);

    // Logic cho Reviewer Offline
    bool canReviewOffline = false;
    bool canCreateSchedule = false;
    bool canConfirmMoving = false;
    bool canConfirmArrival = false;
    bool canUpdateServices = false;
    bool canConfirmSuggestion = false;

    if (!isReviewOnline) {
      switch (status) {
        case BookingStatusType.assigned:
          canCreateSchedule = true;
          break;
        case BookingStatusType.reviewing:
          if (!isStaffEnroute && !isStaffArrived && !isSuggested) {
            canConfirmMoving = true;
          } else if (isStaffEnroute && !isStaffArrived && !isSuggested) {
            canConfirmArrival = true;
          } else if (isStaffArrived && !isSuggested) {
            canUpdateServices = true;
          } else if (isSuggested) {
            canConfirmSuggestion = true;
          }
          break;
        default:
          break;
      }
    }

    // Logic cho Reviewer Online
    bool canReviewOnline = false;
    bool canConfirmReview = false;

    if (isReviewOnline) {
      switch (status) {
        case BookingStatusType.assigned:
          if (hasReviewerAssignment) {
            canConfirmReview = true;
          }
          break;
        case BookingStatusType.reviewing:
          if (!isSuggested) {
            canUpdateServices = true;
          } else if (isSuggested) {
            canConfirmSuggestion = true;
          }
          break;
        default:
          break;
      }
    }

    return BookingStatusResult(
      statusMessage: determineStatusMessage(status, isReviewOnline,
          isStaffEnroute, isStaffArrived, canCreateSchedule),
      canReviewOffline: canReviewOffline,
      canReviewOnline: canReviewOnline,
      canCreateSchedule: canCreateSchedule,
      canConfirmReview: canConfirmReview,
      canUpdateServices: canUpdateServices,
      canConfirmArrival: canConfirmArrival,
      canConfirmMoving: canConfirmMoving,
      canConfirmSuggestion: canConfirmSuggestion,
      isWaitingCustomer: status == BookingStatusType.waiting,
      isWaitingPayment: status == BookingStatusType.depositing,
      isStaffEnroute: isStaffEnroute,
      isStaffArrived: isStaffArrived,
      isSuggested: isSuggested,
      isReviewed: status == BookingStatusType.reviewed,
      isInProgress: status == BookingStatusType.inProgress,
      isCompleted: status == BookingStatusType.completed,
    );
  }, [booking, isReviewOnline]);
}

String determineStatusMessage(
  BookingStatusType status,
  bool isReviewOnline,
  bool isStaffEnroute,
  bool isStaffArrived,
  bool canCreateSchedule,
) {
  if (isReviewOnline) {
    switch (status) {
      case BookingStatusType.assigned:
        return "Đã được phân công";
      case BookingStatusType.reviewing:
        if (isStaffArrived) return "Bạn đang đánh giá tình trạng của nhà";
        return "Đang đợi bạn đánh giá";
      case BookingStatusType.reviewed:
        return "Đã đánh giá xong";
      case BookingStatusType.depositing:
        return "Chờ thanh toán";
      case BookingStatusType.coming:
        return "Đang đến";
      case BookingStatusType.inProgress:
        return "Đang thực hiện";
      case BookingStatusType.completed:
        return "Hoàn thành";
      case BookingStatusType.cancelled:
        return "Đã hủy";
      case BookingStatusType.refunded:
        return "Đã hoàn tiền";
      case BookingStatusType.pending:
        return "Chờ xác nhận";
      default:
        return "Không xác định";
    }
  } else {
    switch (status) {
      case BookingStatusType.assigned:
        return canCreateSchedule
            ? "Chờ bạn xếp lịch với khách hàng"
            : "Đã được phân công";
      case BookingStatusType.waiting:
        return "Đang chờ khách hàng chấp nhận lịch";
      case BookingStatusType.depositing:
        return "Chờ thanh toán";
      case BookingStatusType.reviewing:
        if (isStaffEnroute) return "Xác nhận để di chuyển";
        if (isStaffArrived) {
          return "Bạn đã đến vui lòng đánh giá tình trạng của nhà";
        }
        return "Đang đợi bạn đánh giá";
      case BookingStatusType.reviewed:
        return "Đã đánh giá xong";
      case BookingStatusType.coming:
        return "Đang đến";
      case BookingStatusType.inProgress:
        return "Đang thực hiện";
      case BookingStatusType.completed:
        return "Hoàn thành";
      case BookingStatusType.cancelled:
        return "Đã hủy";
      case BookingStatusType.refunded:
        return "Đã hoàn tiền";
      case BookingStatusType.pending:
        return "Chờ xác nhận";
      default:
        return "Không xác định";
    }
  }
}
