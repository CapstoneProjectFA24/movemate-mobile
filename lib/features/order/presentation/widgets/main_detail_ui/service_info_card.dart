import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
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
    final currentBookingAt =
        ref.watch(bookingStreamProvider(order.id.toString())).value;
    final formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(currentBookingAt.toString()));
    final formattedTime =
        DateFormat('hh:mm').format(DateTime.parse(currentBookingAt.toString()));

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
                buildHouseInformation(),
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
                          content: 'Ngày chuyển nhà:',
                          size: 10,
                          fontFamily: 'bold',
                          color: AssetsConstants.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                        LabelText(
                          content: "$formattedDate  $formattedTime",
                          size: 10,
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
