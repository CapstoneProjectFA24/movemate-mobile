enum OrderPartnerStatusType {
  preparing('PREPARING'),
  ready('READY'),
  upcoming('UPCOMING'),
  completed('COMPLETED'),
  cancelled('CANCELLED');

  final String type;
  const OrderPartnerStatusType(this.type);
}

extension ConvertOrderPartnerStatus on String {
  OrderPartnerStatusType toOrderPartnerTypeEnum() {
    switch (this) {
      case 'Preparing':
        return OrderPartnerStatusType.preparing;
      case 'Ready':
        return OrderPartnerStatusType.ready;
      case 'Upcoming':
        return OrderPartnerStatusType.upcoming;
      case 'Completed':
        return OrderPartnerStatusType.completed;
      case 'Cancelled':
        return OrderPartnerStatusType.cancelled;
      default:
        return OrderPartnerStatusType.preparing;
    }
  }
}
