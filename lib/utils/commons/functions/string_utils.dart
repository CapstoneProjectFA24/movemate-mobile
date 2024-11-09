import 'package:movemate/utils/enums/enums_export.dart';

// String getBookingStatusText(BookingStatusType status) {
//   switch (status) {
//     case BookingStatusType.pending:
//       return 'Đang chờ xếp người đánh giá';
//     case BookingStatusType.depositing:
//       return 'Đang chờ đặt cọc';
//     case BookingStatusType.assigned:
//       return 'Người đánh giá đang xếp lịch';
//     case BookingStatusType.approved:
//       return 'Đã được duyệt';
//     case BookingStatusType.reviewed:
//       return 'Đang chờ tới để đánh giá';
//     case BookingStatusType.coming:
//       return 'Xác nhận dọn nhà';
//     case BookingStatusType.waiting:
//       return 'Xem lịch hẹn';
//     case BookingStatusType.inProgress:
//       return 'Đang thực hiện';
//     case BookingStatusType.completed:
//       return 'Đã hoàn thành';
//     case BookingStatusType.cancelled:
//       return 'Đã hủy';
//     case BookingStatusType.refunded:
//       return 'Đã hoàn tiền';
//   }
// }

class BookingStatusInfo {
  final String statusText;
  final String description;
  final String nextStep;

  BookingStatusInfo({
    required this.statusText,
    required this.description,
    required this.nextStep,
  });
}

BookingStatusInfo getBookingStatusText(BookingStatusType status) {
  switch (status) {
    case BookingStatusType.pending:
      return BookingStatusInfo(
        statusText: 'Đang chờ xếp người đánh giá',
        description: 'Yêu cầu của bạn đang được xử lý',
        nextStep: 'Vui lòng chờ trong vòng 24h',
      );
    case BookingStatusType.depositing:
      return BookingStatusInfo(
        statusText: 'Đang chờ đặt cọc',
        description: 'Bạn cần đặt cọc để xác nhận đặt lịch',
        nextStep: 'Vui lòng thanh toán đặt cọc',
      );
    case BookingStatusType.assigned:
      return BookingStatusInfo(
        statusText: 'Người đánh giá đang xếp lịch',
        description: 'Người đánh giá đã nhận yêu cầu của bạn',
        nextStep: 'Vui lòng chờ xác nhận lịch hẹn',
      );
    case BookingStatusType.approved:
      return BookingStatusInfo(
        statusText: 'Đã được duyệt',
        description: 'Yêu cầu của bạn đã được chấp nhận',
        nextStep: 'Hãy chờ đến ngày đánh giá',
      );
    case BookingStatusType.reviewed:
      return BookingStatusInfo(
        statusText: 'Đang chờ bạn xác nhận',
        description: 'Lịch đánh giá đã được xác nhận',
        nextStep: 'Xác nhận đánh giá online',
      );
    case BookingStatusType.coming:
      return BookingStatusInfo(
        statusText: 'Xác nhận dọn nhà',
        description: 'Sắp đến giờ đánh giá',
        nextStep: 'Hãy chuẩn bị sẵn sàng',
      );
    case BookingStatusType.waiting:
      return BookingStatusInfo(
        statusText: 'Người đánh giá đã xếp lịch xog',
        description: 'Kiểm tra thời gian và địa điểm hẹn',
        nextStep: 'Xem lịch hẹn',
      );
    case BookingStatusType.inProgress:
      return BookingStatusInfo(
        statusText: 'Đang thực hiện',
        description: 'Quá trình đánh giá đang diễn ra',
        nextStep: 'Vui lòng chờ hoàn thành',
      );
    case BookingStatusType.completed:
      return BookingStatusInfo(
        statusText: 'Đã hoàn thành',
        description: 'Quá trình đánh giá đã kết thúc',
        nextStep: 'Cảm ơn bạn đã sử dụng dịch vụ',
      );
    case BookingStatusType.cancelled:
      return BookingStatusInfo(
        statusText: 'Đã hủy',
        description: 'Lịch hẹn đã bị hủy',
        nextStep: 'Bạn có thể đặt lịch mới',
      );
    case BookingStatusType.refunded:
      return BookingStatusInfo(
        statusText: 'Đã hoàn tiền',
        description: 'Tiền đặt cọc đã được hoàn trả',
        nextStep: 'Kiểm tra tài khoản của bạn',
      );
    case BookingStatusType.reviewing:
      return BookingStatusInfo(
        statusText: 'Đang đánh giá',
        description: 'Đang trong quá trình đánh giá',
        nextStep: 'Đã hoàn thành',
      );
  }
}
