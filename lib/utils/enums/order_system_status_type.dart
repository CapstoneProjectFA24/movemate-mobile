enum OrderSystemStatusType {
  instore('IN_STORE'),
  readydelivery('READY_DELIVERY'),
  completed('COMPLETED'),
  cancelled('CANCELLED');

  final String type;
  const OrderSystemStatusType(this.type);
}

extension ConvertOrderSystemStatus on String {
  OrderSystemStatusType toOrderSystemTypeEnum() {
    switch (this) {
      case 'In store':
        return OrderSystemStatusType.instore;
      case 'Ready delivery':
        return OrderSystemStatusType.readydelivery;
      case 'Completed':
        return OrderSystemStatusType.completed;
      case 'Cancelled':
        return OrderSystemStatusType.cancelled;
      default:
        return OrderSystemStatusType.instore;
    }
  }
}
