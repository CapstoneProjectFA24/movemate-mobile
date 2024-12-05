import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';

class ReservationCard extends StatelessWidget {
  final BookingTrackersIncidentEntity reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final trackerSourceURL = reservation.trackerSources.first;

    final timeString = reservation.time;
    final dateParts = timeString.split(" ")[0].split("-");
    final timeParts = timeString.split(" ")[1].split(":");
    final dateTime = DateTime(
      int.parse(dateParts[0]) + 2000, // Năm
      int.parse(dateParts[1]), // Tháng
      int.parse(dateParts[2]), // Ngày
      int.parse(timeParts[0]), // Giờ
      int.parse(timeParts[1]), // Phút
      int.parse(timeParts[2]), // Giây
    );

    final day = DateFormat('EE').format(dateTime); // Thứ
    final date = DateFormat('dd MMM yyyy').format(dateTime); // Ngày
    final time = DateFormat('HH:mm').format(dateTime); // Giờ

    // Chuyển đổi status sang tiếng Việt
    String statusText = '';
    Color statusColor = Colors.black;
    switch (reservation.status) {
      case 'PENDING':
        statusText = 'Đang chờ nhân viên duyệt';
        statusColor = Colors.orange;
        break;
      case 'WAITING':
        statusText = 'Chờ quản lý duyệt';
        statusColor = Colors.blue;
        break;
      case 'AVAILABLE':
        statusText = 'Đã bồi thường';
        statusColor = Colors.green;
        break;
      case 'NOTAVAILABLE':
        statusText = 'Không bồi thường';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Trạng thái không xác định';
        statusColor = Colors.grey;
    }

    // Xử lý realAmount nếu là null
    final realAmountText = reservation.realAmount != null
        ? formatPrice(reservation.realAmount?.toInt() ?? 0)
        : 'Đang chờ...';

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // Hình lớn
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Image.network(
                    trackerSourceURL.resourceUrl ??
                        'https://res.cloudinary.com/dietfw7lr/image/upload/v1733425759/fojgatdijoy3695lkbys.jpg',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://res.cloudinary.com/dietfw7lr/image/upload/v1733425759/fojgatdijoy3695lkbys.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Row(
                      children: [
                        Text(
                          'Ước tính: ${formatPrice(reservation.estimatedAmount.toInt())}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Nội dung chính
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservation.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    child: Text("${reservation.failedReason} reason "),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: reservation.trackerSources
                        .map((icon) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                icon.resourceUrl ??
                                    'https://res.cloudinary.com/dietfw7lr/image/upload/v1733425759/fojgatdijoy3695lkbys.jpg',
                                width: 20,
                                height: 20,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://res.cloudinary.com/dietfw7lr/image/upload/v1733425759/fojgatdijoy3695lkbys.jpg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Estimated and Real Amount
                  Row(
                    children: [
                      const Text(
                        'Thực tế: ',
                        style: TextStyle(
                            fontSize: 16), // Kích thước font của "Thực tế:"
                      ),
                      Text(
                        realAmountText,
                        style: TextStyle(
                          fontSize: realAmountText == 'Đang chờ...'
                              ? 12
                              : 16, // Điều chỉnh kích thước font nếu là "Đang chờ..."
                          color: Colors
                              .grey, // Có thể thêm màu sắc cho "Đang chờ..."
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
            // Thông tin trạng thái và ngày tháng
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(day),
                      Text(time),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
