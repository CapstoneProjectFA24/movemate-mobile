import 'package:movemate/utils/enums/enums_export.dart';

String getBookingStatusText(BookingStatusType status) {
  switch (status) {
    case BookingStatusType.pending:
      return 'Đang chờ xử lý';
    case BookingStatusType.depositing:
      return 'Đang chờ đặt cọc';
    case BookingStatusType.assigned:
      return 'Đã được phân công';
    case BookingStatusType.approved:
      return 'Đã được duyệt';
    case BookingStatusType.reviewed:
      return 'Đang chờ reviewer xét duyệt';
    case BookingStatusType.coming:
      return 'Đang đến';
    case BookingStatusType.waiting:
      return 'Đang chờ';
    case BookingStatusType.inProgress:
      return 'Đang thực hiện';
    case BookingStatusType.completed:
      return 'Đã hoàn thành';
    case BookingStatusType.cancelled:
      return 'Đã hủy';
    case BookingStatusType.refunded:
      return 'Đã hoàn tiền';
  }
}
