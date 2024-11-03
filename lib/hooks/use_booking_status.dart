import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/services/map_services/booking_realtime_entity/booking_realtime_entity.dart';

enum BookingStatus {
  pending,
  assigned,
  waiting,
  depositing,
  reviewing,
  reviewed,
  coming,
  cancel,
  refunded,
  inProgress,
  inTransit,
  delivered,
  unloaded,
  completed
}

enum BookingStateAssign {
  waiting,
  assigned,
  enroute,
  arrived,
  inProgress,
  inTransit,
  delivered,
  unloaded,
  suggested,
  reviewed,
  completed,
  failed,
  cancelled,
  refunded
}

class BookingStatusResult {
  final String statusMessage;
  final bool canReviewOffline;
  final bool canReviewOnline;
  final bool isWaitingForPayment;
  final bool isStaffEnroute;
  final bool isStaffArrived;
  final bool isReviewed;
  final bool isInProgress;
  final bool isInTransit;
  final bool isDelivered;
  final bool isCompleted;
  final bool isSuggested;

  BookingStatusResult({
    required this.statusMessage,
    required this.canReviewOffline,
    required this.canReviewOnline,
    required this.isWaitingForPayment,
    required this.isStaffEnroute,
    required this.isStaffArrived,
    required this.isReviewed,
    required this.isInProgress,
    required this.isInTransit,
    required this.isDelivered,
    required this.isCompleted,
    required this.isSuggested,
  });
}

BookingStatusResult useBookingStatus(
    BookingRealtimeEntity? booking, bool isReviewOnline) {
  return useMemoized(() {
    if (booking == null) {
      return BookingStatusResult(
        statusMessage: "",
        canReviewOffline: false,
        canReviewOnline: false,
        isWaitingForPayment: false,
        isStaffEnroute: false,
        isStaffArrived: false,
        isReviewed: false,
        isInProgress: false,
        isInTransit: false,
        isDelivered: false,
        isCompleted: false,
        isSuggested: false,
      );
    }

    final assignments = booking.assignments ?? [];
    final status = booking.status;

    // Check for offline reviewer assignment
    final hasReviewer = assignments.any((assignment) =>
        assignment.status == BookingStateAssign.suggested.toString() &&
        assignment.staffType == "REVIEWER");

    // Check if any assignment is in SUGGESTED state
    final isSuggested = assignments.any((assignment) =>
        assignment.status == BookingStateAssign.suggested.toString());

    // Determine review capabilities
    final canReviewOffline = hasReviewer &&
        (status == BookingStatus.reviewing.toString() && !isReviewOnline);

    final canReviewOnline =
        isReviewOnline && status == BookingStatus.reviewing.toString();

    // Check staff status
    final isStaffEnroute = assignments
        .any((a) => a.status == BookingStateAssign.enroute.toString());

    final isStaffArrived = assignments
        .any((a) => a.status == BookingStateAssign.arrived.toString());

    // Check delivery status
    final isInProgress = assignments
        .any((a) => a.status == BookingStateAssign.inProgress.toString());

    final isInTransit = status == BookingStatus.inTransit.toString() ||
        assignments
            .any((a) => a.status == BookingStateAssign.inTransit.toString());

    final isDelivered = assignments
        .any((a) => a.status == BookingStateAssign.delivered.toString());

    final isCompleted = status == BookingStatus.completed.toString() ||
        assignments
            .any((a) => a.status == BookingStateAssign.completed.toString());

    // Determine status message
    String statusMessage = "";
    String description = '';
    switch (status) {
      case "PENDING":
        statusMessage = "Chờ xác nhận";
        description = "";
        break;
      case "DEPOSITING":
        statusMessage = "Chờ khách hàng thanh toán";
        break;
      case "ASSIGNED":
        statusMessage = canReviewOffline
            ? "Chờ bạn xếp lịch với khách hàng"
            : "Đã được phân công";
        break;
      case "WAITING":
        statusMessage = "Đang chờ khách hàng chấp nhận lịch";
        break;
      case "REVIEWING":
        if (isStaffEnroute) {
          statusMessage = "Nhân viên đang di chuyển";
        } else if (isStaffArrived) {
          statusMessage = "Nhân viên đã đến";
        } else {
          statusMessage = "Đang đợi bạn đánh giá";
        }
        break;
      case "REVIEWED":
        statusMessage = "Đã đánh giá xong";
        break;
      case "IN_PROGRESS":
        statusMessage = "Đang thực hiện";
        break;
      case "IN_TRANSIT":
        statusMessage = "Đang vận chuyển";
        break;
      case "DELIVERED":
        statusMessage = "Đã giao hàng";
        break;
      case "COMPLETED":
        statusMessage = "Hoàn thành";
        break;
      case "CANCEL":
        statusMessage = "Đã hủy";
        break;
      case "REFUNDED":
        statusMessage = "Đã hoàn tiền";
        break;
      default:
        statusMessage = "Không xác định";
    }

    return BookingStatusResult(
      statusMessage: statusMessage,
      canReviewOffline: canReviewOffline,
      canReviewOnline: canReviewOnline,
      isWaitingForPayment: status == BookingStatus.depositing.toString(),
      isStaffEnroute: isStaffEnroute,
      isStaffArrived: isStaffArrived,
      isReviewed: status == BookingStatus.reviewed.toString(),
      isInProgress: isInProgress,
      isInTransit: isInTransit,
      isDelivered: isDelivered,
      isCompleted: isCompleted,
      isSuggested: isSuggested,
    );
  }, [booking]);
}
