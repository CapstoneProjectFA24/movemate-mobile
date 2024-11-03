// components/service_info_card.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:movemate/features/order/presentation/widgets/details/address.dart';
import 'package:movemate/features/order/presentation/widgets/details/column.dart';

class ServiceInfoCard extends StatelessWidget {
  static const double cardWidth = 350.0;
  static const double borderRadius = 10.0;
  static const double padding = 16.0;
  static const double spacing = 10.0;

  final OrderEntity order;
  final HouseTypeEntity? houseType;
  final ProfileEntity? profileUser;
  final AsyncValue<BookingStatusType> statusAsync;

  const ServiceInfoCard({
    super.key,
    required this.order,
    required this.houseType,
    required this.statusAsync,
    required this.profileUser,
  });

  @override
  Widget build(BuildContext context) {
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
                buildAddressInformation(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              content: 'Loại nhà : ${houseType?.name ?? "label"}',
              size: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: spacing),
            buildDetailColumn(
              FontAwesomeIcons.building,
              "Tầng :${order.floorsNumber}",
            ),
            buildDetailColumn(
              FontAwesomeIcons.building,
              "Phòng : ${order.roomNumber}",
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAddressInformation() {
    return Column(
      children: [
        buildAddressRow(
          Icons.location_on_outlined,
          buildPickupAddressText(),
        ),
        const Divider(height: 12, color: Colors.grey, thickness: 1),
        buildAddressRow(
          Icons.location_searching,
          'Đến : ${order.pickupAddress}',
        ),
      ],
    );
  }

  String buildPickupAddressText() {
    return '''Từ:  ${order.pickupAddress}
Số điện thoại: ${profileUser?.phone}
Tên: ${profileUser?.name}
Email: ${profileUser?.email}''';
  }
}
