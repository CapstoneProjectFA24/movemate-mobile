enum BookingStatusType {
  pending('PENDING'),
  depositing('DEPOSITING'),
  assigned('ASSIGNED'),
  approved('APPROVED'),
  reviewed('REVIEWED'),
  coming('COMMING'),
  waiting('WAITING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  cancelled('CANCEL'),
  refunded('REFUNDED');

  final String type;
  const BookingStatusType(this.type);
}

extension ConvertOrderPartnerStatus on String {
  BookingStatusType toBookingTypeEnum() {
    switch (this.toUpperCase()) {
      case 'PENDING':
        return BookingStatusType.pending;
      case 'DEPOSITING':
        return BookingStatusType.depositing;
      case 'ASSIGNED':
        return BookingStatusType.assigned;
      case 'APPROVED':
        return BookingStatusType.approved;
      case 'REVIEWED':
        return BookingStatusType.reviewed;
      case 'COMMING':
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
}
