import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import Riverpod
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart'; // Import booking_provider
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceItem {
  final String title;
  final int quantity;
  final double totalPrice;

  ServiceItem({
    required this.title,
    required this.quantity,
    required this.totalPrice,
  });

  // Thêm phương thức sao chép để dễ dàng cập nhật giá trị
  ServiceItem copyWith({
    String? title,
    double? unitPrice,
    int? quantity,
    double? totalPrice,
  }) {
    return ServiceItem(
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

class PriceDetailModal extends ConsumerWidget {
  final VoidCallback? onConfirm;

  const PriceDetailModal({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingStateResponse = ref.watch(bookingResponseProviderPrice);

    // Tạo danh sách các dịch vụ đã chọn
    List<ServiceItem> allSelectedServices = [
      ...bookingStateResponse!.bookingDetails.map((subService) => ServiceItem(
            title: subService.name,
            quantity: subService.quantity,
            totalPrice: subService.price,
          )),
      ...bookingStateResponse.feeDetails.map((fee) => ServiceItem(
            title: fee.name,
            quantity: fee.quantity ?? 1,
            totalPrice: fee.amount,
          )),
    ];

    return Container(
      color: AssetsConstants.whiteColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Title
          const Text(
            'Chi tiết giá',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AssetsConstants.blackColor,
            ),
          ),
          const SizedBox(height: 8),
          // Scrollable List of Services
          Expanded(
            child: ListView.builder(
              itemCount: allSelectedServices.length,
              itemBuilder: (context, index) {
                final service = allSelectedServices[index];
                return buildPriceDetailRow(
                  service.title,
                  service.totalPrice,
                  service.quantity,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Fixed Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatPrice(bookingStateResponse.total.toInt()),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AssetsConstants.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Fixed Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm ??
                  () {
                    Navigator.pop(context); // Default action
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: AssetsConstants.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AssetsConstants.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper để hiển thị mỗi hàng chi tiết giá
  Widget buildPriceDetailRow(String title, double price, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          // Cột Title
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          // Cột Quantity
          Expanded(
            flex: 1,
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // Cột Price
          Expanded(
            flex: 3,
            child: Text(
              formatPrice(price.toInt()),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
