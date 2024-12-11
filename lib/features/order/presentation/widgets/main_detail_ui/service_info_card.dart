import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/change_booking_date_time_modal.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

class ServiceInfoCard extends HookConsumerWidget {
  static const double cardWidth = 350.0;
  static const double borderRadius = 10.0;
  static const double padding = 16.0;
  static const double spacing = 10.0;

  final OrderEntity order;
  final HouseTypeEntity? houseType;

  const ServiceInfoCard({
    super.key,
    required this.order,
    required this.houseType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userdata = ref.read(authProvider);

    final formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(order.bookingAt.toString()));

    final formattedTime =
        DateFormat('HH:mm').format(DateTime.parse(order.bookingAt.toString()));

    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));

    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline ?? false);
    // final checkDateTimeChange = currentBookingAt!.bookingAt ?? order.bookingAt;

    DateTime? bookingAtDateTime = parseBookingAt(order.bookingAt);

    if (bookingAtDateTime == null) {
      // Hiển thị thông báo lỗi nếu phân tích ngày thất bại
      return const Center(child: Text('Invalid booking date format.'));
    }
    // Tính thời gian trước 1 giờ của bookingAt
    final DateTime oneHourBeforeBooking =
        bookingAtDateTime.subtract(const Duration(hours: 1));

    // Lấy thời gian hiện tại
    final DateTime now = DateTime.now();

    // Kiểm tra xem hiện tại có trước thời gian bookingAt trừ đi 1 giờ hay không
    final bool isBeforeOneHour = now.isBefore(oneHourBeforeBooking);
    // print("checking date time 1 $isBeforeOneHour");
    // print("checking date time 2 $bookingAtDateTime");
    // print("checking date time 3 $oneHourBeforeBooking");
    // print("checking date time 4 ${order.bookingAt}");
    bool isChangeDateEnabled() {
      return bookingStatus.canReviewSuggestion ||
          bookingStatus.canAcceptSchedule ||
          bookingStatus.isWaitingStaffSchedule ||
          bookingStatus.isProcessingRequest ||
          bookingStatus.isOnlineReviewing ||
          bookingStatus.isOnlineSuggestionReady ||
          bookingStatus.canMakePayment ||
          isBeforeOneHour;
    }

    // Xác định xem nút có được bật hay không
    bool isButtonEnabled = isChangeDateEnabled() &&
        (order.isUpdated == null || order.isUpdated == false) &&
        !bookingStatus.canMakePaymentLast &&
        !bookingStatus.isCompleted;

    return FadeInUp(
      child: Center(
        child: Container(
          width: cardWidth,
          decoration: buildCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildHouseInformation(),
                    ),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              // Hiển thị modal để thay đổi ngày và giờ
                              showChangeBookingDateTimeModal(context);
                            }
                          : () {}, // Nếu không được bật, onPressed sẽ là null để vô hiệu hóa nút
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? AssetsConstants.mainColor.withOpacity(0.7)
                            : Colors.grey, // Màu nền tùy theo trạng thái
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        order.isUpdated == true
                            ? 'Đã đổi ngày'
                            : 'Thay đổi ngày',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: spacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần tên và số điện thoại
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Text(
                        '''Tên: ${userdata?.name}
Số điện thoại: ${userdata?.phone}
''',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Phần "Từ" có biểu tượng
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Từ: ${order.pickupAddress}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Dòng phân cách
                    const Divider(height: 12, color: Colors.grey, thickness: 1),

                    // Phần "Đến" có biểu tượng
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_searching,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Đến: ${order.deliveryAddress}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: spacing),

                // Phần ngày tạo
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LabelText(
                          content: 'Ngày chuyển nhà: ',
                          size: 12,
                          color: AssetsConstants.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                        LabelText(
                          content: "$formattedTime $formattedDate",
                          size: 12,
                          color: AssetsConstants.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showChangeBookingDateTimeModal(BuildContext context) {
    // Code to show the modal for changing date and time
    // This can be extracted into a separate component
    showDialog(
      // barrierColor: Colors.white10,
      barrierDismissible: false,
      context: context,
      builder: (context) => ChangeBookingDateTimeModal(
        order: order,
        bookingId: order.id,
        initialDate: DateTime.parse(order.bookingAt.toString()),
        onDateTimeChanged: (newDateTime) {
          // Handle the new date and time selected by the user
          // and update the order entity accordingly
        },
      ),
    );
  }

  BoxDecoration buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4,
        ),
      ],
    );
  }

  Widget buildHouseInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          content: 'Loại nhà : ${houseType?.name ?? "label"}',
          size: 14,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Icon(
                  FontAwesomeIcons.building,
                  size: 16,
                  color: Colors.black87,
                ),
                Text(
                  "Tầng: ${order.floorsNumber}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                const Icon(
                  FontAwesomeIcons.doorClosed,
                  size: 16,
                  color: Colors.black87,
                ),
                Text(
                  "Phòng: ${order.roomNumber}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDetailColumn(IconData icon, String content) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

/// Hàm để phân tích `bookingAt` từ `order.bookingAt`
DateTime? parseBookingAt(dynamic bookingAt) {
  try {
    if (bookingAt is String) {
      // Sử dụng DateTime.parse nếu định dạng là chuẩn ISO 8601 hoặc tương tự
      return DateTime.parse(bookingAt);
    } else if (bookingAt is DateTime) {
      // Nếu bookingAt đã là đối tượng DateTime
      return bookingAt;
    } else {
      // Nếu định dạng không được hỗ trợ
      throw const FormatException('Unsupported type for bookingAt');
    }
  } catch (e) {
    // Xử lý lỗi nếu có
    print('Error parsing bookingAt: $e');
    return null;
  }
}
