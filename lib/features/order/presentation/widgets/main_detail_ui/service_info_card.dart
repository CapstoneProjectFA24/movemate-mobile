// components/service_info_card.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/order/presentation/widgets/details/address.dart';
import 'package:movemate/features/order/presentation/widgets/details/column.dart';
import 'package:movemate/features/order/presentation/widgets/details/policies.dart';
import 'package:movemate/features/order/presentation/widgets/details/booking_code.dart';

class ServiceInfoCard extends StatelessWidget {
  final OrderEntity order;
  final HouseTypeEntity? houseType;

  const ServiceInfoCard({
    super.key,
    required this.order,
    required this.houseType,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AssetsConstants.primaryMain,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(15),
                child: const Row(
                  children: [
                    Icon(FontAwesomeIcons.home, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Thông tin dịch vụ',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại nhà : ${houseType?.name ?? "label"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildAddressRow(
                      Icons.location_on_outlined,
                      'Từ:  ${order.pickupAddress} ',
                    ),
                    const Divider(height: 12, color: Colors.grey, thickness: 1),
                    buildAddressRow(
                      Icons.location_searching,
                      'Đến : ${order.pickupAddress}',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDetailColumn(FontAwesomeIcons.building,
                            "Tầng :${order.floorsNumber}"),
                        buildDetailColumn(FontAwesomeIcons.building,
                            "Phòng : ${order.roomNumber}"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildPolicies(
                        FontAwesomeIcons.checkCircle, 'Miễn phí hủy đơn hàng'),
                    const SizedBox(height: 20),
                    buildPolicies(FontAwesomeIcons.checkCircle,
                        'Áp dụng chính sách đổi lịch'),
                    const SizedBox(height: 20),
                    buildBookingCode('Mã khuyến mãi', 'FD8UH6'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
