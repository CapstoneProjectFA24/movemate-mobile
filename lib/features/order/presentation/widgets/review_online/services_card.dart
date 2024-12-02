import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';
import 'package:movemate/features/order/presentation/widgets/review_online/house_information.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceCard extends HookConsumerWidget {
  final OrderEntity order;
  final OrderEntity? orderOld;
  final ProfileEntity? profileUserAssign;
  final TruckCategoryEntity? truckCateDetails;

  const ServiceCard({
    super.key,
    required this.order,
    required this.orderOld,
    required this.profileUserAssign,
    required this.truckCateDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingOverlay(
      isLoading: truckCateDetails == null,
      child: Container(
        width: double.infinity,
        height: 520, // Cố định chiều cao của ServiceCard
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HouseInformation(
                        order: order,
                        orderOld: orderOld,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                child: ListView.builder(
                  itemCount:
                      order.bookingDetails.length + order.feeDetails.length + 1,
                  itemBuilder: (context, index) {
                    if (index < order.bookingDetails.length) {
                      final newService = order.bookingDetails[index];
                      final oldService = orderOld?.bookingDetails.firstWhere(
                        (e) =>
                            e.serviceId == newService.serviceId &&
                            e.type == "TRUCK",
                        orElse: () => BookingDetailResponseEntity(
                          bookingId: 0,
                          id: 0,
                          type: "TRUCK",
                          serviceId: 0,
                          quantity: 0,
                          price: 0,
                          status: "READY",
                          name: "No Service",
                          description: "No description",
                          imageUrl: "",
                        ),
                      );
                      return buildPriceItem(newService.name,
                          formatPrice(newService.price.toInt()));
                    }
                    // Handle other cases like deposit and feeDetails
                    return Container(); // Placeholder for other cases
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tổng giá
            if (orderOld != null) ...[
              if (order.total == orderOld?.total)
                buildSummary('Tổng giá', formatPrice(order.total.toInt()),
                    fontWeight: FontWeight.w600)
              else ...[
                buildPriceItem(
                    'Tổng giá cũ', formatPrice(orderOld!.total.toInt()),
                    isStrikethrough: true),
                buildSummary('Tổng giá mới', formatPrice(order.total.toInt()),
                    fontWeight: FontWeight.w600),
              ]
            ] else ...[
              buildSummary('Tổng giá', formatPrice(order.total.toInt()),
                  fontWeight: FontWeight.w600),
            ],
          ],
        ),
      ),
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
