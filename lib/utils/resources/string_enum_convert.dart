import 'package:movemate/utils/enums/enums_export.dart';

String getTitleSystemStatus(OrderSystemStatusType type) {
  switch (type) {
    case OrderSystemStatusType.instore:
      return 'Trong cửa hàng';
    case OrderSystemStatusType.readydelivery:
      return 'Sẵn sàng giao';
    case OrderSystemStatusType.completed:
      return 'Hoàn thành';
    case OrderSystemStatusType.cancelled:
      return 'Đã hủy';
    default:
      return 'Unknow!';
  }
}

String getTitlePartnerStatus(OrderPartnerStatusType type) {
  switch (type) {
    case OrderPartnerStatusType.preparing:
      return 'Đang chuẩn bị';
    case OrderPartnerStatusType.upcoming:
      return 'Đặt trước';
    case OrderPartnerStatusType.ready:
      return 'Sẵn sàng';
    case OrderPartnerStatusType.completed:
      return 'Hoàn thành';
    case OrderPartnerStatusType.cancelled:
      return 'Đã hủy';
    default:
      return 'Unknow!';
  }
}


String getTitleCategoryType(CategoryType type) {
  switch (type) {
    case CategoryType.normal:
      return 'Danh mục thường';
    case CategoryType.extra:
      return 'Danh mục thêm';
    default:
      return 'Unknow!';
  }
}