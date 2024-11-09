import 'dart:ui';

import 'package:movemate/utils/constants/asset_constant.dart';

enum BookingStatusType {
  pending('PENDING'),
  depositing('DEPOSITING'),
  assigned('ASSIGNED'),
  reviewed('REVIEWED'),
  approved('APPROVED'),
  reviewing('REVIEWING'),
  coming('COMING'),
  waiting('WAITING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  cancelled('CANCEL'),
  refunded('REFUNDED');

  final String type;
  const BookingStatusType(this.type);
}

enum AssignmentsStatusType {
  assigned('ASSIGNED'),
  incoming('INCOMING'),
  arrived('ARRIVED'),
  reviewing('REVIEWING'),
  suggested('SUGGESTED'),
  reviewed('REVIEWED'),
  inProgress('IN_PROGRESS'),
  inTransit('IN_TRANSIT'),
  delivered('DELIVERED'),
  completed('COMPLETED');

  final String type;
  const AssignmentsStatusType(this.type);
}

extension ConvertOrderPartnerStatus on String {
  BookingStatusType toBookingTypeEnum() {
    switch (toUpperCase()) {
      case 'PENDING':
        return BookingStatusType.pending;
      case 'DEPOSITING':
        return BookingStatusType.depositing;
      case 'ASSIGNED':
        return BookingStatusType.assigned;
      case 'REVIEWED':
        return BookingStatusType.reviewed;
      case 'APPROVED':
        return BookingStatusType.approved;
      case 'REVIEWING':
        return BookingStatusType.reviewing;
      case 'COMING':
        return BookingStatusType.coming;
      case 'WAITING':
        return BookingStatusType.waiting;
      case 'IN_PROGRESS':
        return BookingStatusType.inProgress;
      case 'COMPLETED':
        return BookingStatusType.completed;
      case 'CANCEL':
        return BookingStatusType.cancelled;
      case 'REFUNDED':
        return BookingStatusType.refunded;
      default:
        return BookingStatusType.pending;
    }
  }

  AssignmentsStatusType toAssignmentsTypeEnum() {
    switch (toUpperCase()) {
      case 'ASSIGNED':
        return AssignmentsStatusType.assigned;
      case 'INCOMING':
        return AssignmentsStatusType.incoming;
      case 'ARRIVED':
        return AssignmentsStatusType.arrived;
      case 'REVIEWING':
        return AssignmentsStatusType.reviewing;
      case 'SUGGESTED':
        return AssignmentsStatusType.suggested;
      case 'REVIEWED':
        return AssignmentsStatusType.reviewed;
      case 'IN_PROGRESS':
        return AssignmentsStatusType.inProgress;
      case 'IN_TRANSIT':
        return AssignmentsStatusType.inTransit;
      case 'DELIVERED':
        return AssignmentsStatusType.delivered;
      case 'COMPLETED':
        return AssignmentsStatusType.completed;
      default:
        return AssignmentsStatusType.incoming;
    }
  }
}

// Helper method to get status color
Color getStatusColor(BookingStatusType status) {
  switch (status) {
    case BookingStatusType.depositing:
      return AssetsConstants.errorMain; // Red color
    case BookingStatusType.pending:
      return AssetsConstants.warningMain; // Yellow color
    case BookingStatusType.assigned:
      return AssetsConstants.secondaryMain; // Blueish color
    case BookingStatusType.approved:
      return AssetsConstants.successMain; // Green color
    case BookingStatusType.completed:
      return AssetsConstants.purpleMain; // Purple color
    case BookingStatusType.cancelled:
      return AssetsConstants.greyColor; // Grey color
    case BookingStatusType.refunded:
      return AssetsConstants.pinkColor; // Pink color
    default:
      return AssetsConstants.primaryMain; // Default primary color
  }
}
