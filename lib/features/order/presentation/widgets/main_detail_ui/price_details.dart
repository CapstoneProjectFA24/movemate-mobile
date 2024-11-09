import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/presentation/widgets/details/item.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';

class PriceDetails extends ConsumerWidget {
  final OrderEntity order;
  final AsyncValue<BookingStatusType> statusAsync;
  final List<ServicesPackageEntity> serviceAll;
  const PriceDetails({
    super.key,
    required this.order,
    required this.serviceAll, // thêm dữ liệu serviceAll vào để lấy thông tin service tương ứng

    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hàm hỗ trợ để định dạng giá
    String formatPrice(int price) {
      final formatter = NumberFormat('#,###', 'vi_VN');
      return '${formatter.format(price)} đ';
    }

    // Lấy danh sách inverseParentService từ serviceAll
    final List<SubServiceEntity> inverseParentServiceList =
        serviceAll.expand((service) => service.inverseParentService).toList();

    // Lấy danh sách serviceId từ bookingDetails
    final List<int> getServices = order.bookingDetails
        .where((detail) => detail.type == "TRUCK")
        .map((truckDetail) => truckDetail.serviceId)
        .whereType<int>()
        .toList();

    // Hàm tìm imageUrl từ truckCategory dựa trên serviceId
    String? findImageUrl(int serviceId) {
      final matchingService = inverseParentServiceList.firstWhere(
        (subService) => subService.id == serviceId,
        orElse: () => SubServiceEntity(
          id: -1,
          name: 'Unknown',
          truckCategory: null,
          isQuantity: false,
          amount: 0,
          description: '',
          discountRate: 0,
          imageUrl: '',
          isActived: false,
          quantityMax: 0,
          tier: 0,
          type: '',
        ),
      );

      return matchingService.truckCategory?.imageUrl;
    }

    print("tìm ảnh  ${findImageUrl(getServices.first)}");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // Increased border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24), // Increased padding
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelText(
                content: 'Chi tiết giá',
                size: 20, // Increased font size
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              // You can add more widgets here if needed
            ],
          ),
          const SizedBox(height: 20), // Increased spacing

          // Truck details
          ...order.bookingDetails
              .where((detail) => detail.type == "TRUCK")
              .map((truckDetail) {
            // Tìm imageUrl cho truckDetail này
            String imageUrl = findImageUrl(truckDetail.serviceId) ??
                'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728489912/movemate/vs174go4uz7uw1g9js2e.jpg';

            return buildItem(
              imageUrl: imageUrl,
              title: truckDetail.name ?? 'Xe Tải',
              description: truckDetail.description ?? 'Không có mô tả',
            );
          }),

          // Price details
          ...order.bookingDetails.map<Widget>((detail) {
            return buildPriceItem(
              detail.name ?? '',
              formatPrice(detail.price.toInt()),
            );
          }),

          const SizedBox(height: 16),
          buildSummary('Tiền đặt cọc', formatPrice(order.deposit.toInt())),
          // Hiển thị các fee từ feeDetails
          ...order.feeDetails.map((fee) {
            return buildSummary(
              fee.name,
              formatPrice(fee.amount.toInt()),
            );
          }),

          const Divider(
            color: Colors.grey,
            thickness: 1.5, // Increased thickness
            height: 32, // Added height for better spacing
          ),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: LabelText(
                  content: 'Tổng giá',
                  size: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: LabelText(
                  content: formatPrice(order.totalReal.toInt()),
                  size: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Note section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText(
                  content: 'Ghi chú',
                  size: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                LabelText(
                  content:
                      "${order.note!.isEmpty ? 'Không có ghi chú' : order.note}",
                  size: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  maxLine: 3,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Status button
          statusAsync.when(
            data: (status) {
              final isButtonEnabled = status == BookingStatusType.waiting ||
                  status == BookingStatusType.depositing ||
                  status == BookingStatusType.reviewed ||
                  status == BookingStatusType.coming;

              String buttonText = getBookingStatusText(status).nextStep;

              return SizedBox(
                width: double.infinity,
                height: 54, // Increased height
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          if (status == BookingStatusType.depositing) {
                            context.pushRoute(PaymentScreenRoute(id: order.id));
                          } else if (status == BookingStatusType.reviewed &&
                              order.isReviewOnline == true) {
                            context.pushRoute(ReviewOnlineRoute(order: order));
                          } else if (status == BookingStatusType.reviewed &&
                              order.isReviewOnline == false) {
                            context.pushRoute(ReviewAtHomeRoute(order: order));
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? const Color(0xFFFF9900)
                        : Colors.grey[300],
                    elevation: isButtonEnabled ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: LabelText(
                    content: buttonText,
                    size: 16,
                    color: isButtonEnabled ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
              ),
            ),
            error: (err, stack) => LabelText(
              content: 'Error: $err',
              size: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
