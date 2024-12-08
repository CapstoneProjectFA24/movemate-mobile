import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';

class ReservationCard extends HookConsumerWidget {
  final BookingTrackersIncidentEntity reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Xử lý thời gian
    final timeString = reservation.time;
    final dateParts = timeString.split(" ")[0].split("-");
    final timeParts = timeString.split(" ")[1].split(":");
    final dateTime = DateTime(
      int.parse(dateParts[0]) + 2000,
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );

    final day = DateFormat('EE').format(dateTime);
    final date = DateFormat('dd MMM yyyy').format(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);

    // Xử lý status
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

    // Xử lý realAmount
    final realAmountText = reservation.realAmount != null
        ? formatPrice(reservation.realAmount?.toInt() ?? 0)
        : 'Đang chờ...';

    return GestureDetector(
      onTap: () {
        context.router.push(IncidentDetailsScreenRoute(incident: reservation));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh chính và thông tin ước tính
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: reservation.trackerSources.isNotEmpty
                          ? Image.network(
                              reservation.trackerSources.first.resourceUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                );
                              },
                            )
                          : const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Nội dung chính
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Ước tính: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            ' ${formatPrice(reservation.estimatedAmount.toInt())}',
                            style: TextStyle(
                              fontSize:
                                  realAmountText == 'Đang chờ...' ? 12 : 14,
                              color: const Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Thực tế: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            realAmountText,
                            style: TextStyle(
                              fontSize:
                                  realAmountText == 'Đang chờ...' ? 12 : 14,
                              color: const Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Thời gian
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Danh sách ảnh
            // if (reservation.trackerSources.isNotEmpty)
            //   SizedBox(
            //     height: 60,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: reservation.trackerSources.length,
            //       itemBuilder: (context, index) {
            //         final source = reservation.trackerSources[index];
            //         return Container(
            //           margin: const EdgeInsets.only(right: 8),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(6),
            //             child: Image.network(
            //               source.resourceUrl ??
            //                   'https://res.cloudinary.com/dietfw7lr/image/upload/v1733425759/fojgatdijoy3695lkbys.jpg',
            //               width: 60,
            //               height: 60,
            //               fit: BoxFit.cover,
            //               errorBuilder: (context, error, stackTrace) {
            //                 return Container(
            //                   width: 60,
            //                   height: 60,
            //                   color: Colors.grey[300],
            //                   child: const Icon(Icons.error, size: 20),
            //                 );
            //               },
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price)} đ';
  }
}
