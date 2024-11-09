import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import Riverpod
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart'; // Import booking_provider
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceItem {
  final String title;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  ServiceItem({
    required this.title,
    required this.unitPrice,
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
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(double price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

class PriceDetailModal extends ConsumerWidget {
  final VoidCallback? onConfirm; // Add this line

  const PriceDetailModal({super.key, this.onConfirm}); // Update constructor

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final priceFormat = NumberFormat('#,###', 'vi_VN');

    // Tạo danh sách các dịch vụ đã chọn
    List<ServiceItem> allSelectedServices = [
      ...bookingState.selectedSubServices.map((subService) => ServiceItem(
            title: subService.name,
            unitPrice: subService.discountRate,
            quantity: subService.quantity ?? 1,
            totalPrice: subService.amount * (subService.quantity ?? 1),
          )),
      ...bookingState.servicesFeeList.map((fee) => ServiceItem(
            title: fee.name,
            unitPrice: fee.amount.toDouble(),
            quantity: fee.quantity ?? 1,
            totalPrice: (fee.amount * (fee.quantity ?? 1)).toDouble(),
          )),
      // Thêm giá của phí khác nếu có
      if (bookingState.selectedPackages.any((e) => e.amount > 0))
        ...bookingState.selectedPackages
            .where((e) => e.amount > 0)
            .map((package) => ServiceItem(
                  title: package.name,
                  unitPrice: package.amount,
                  quantity: package.quantity ?? 1,
                  totalPrice: package.amount * (package.quantity ?? 1),
                )),
      // Thêm giá của phương tiện nếu có
      if (bookingState.selectedVehicle != null)
        ServiceItem(
          title: bookingState.selectedVehicle!.name,
          unitPrice: bookingState.selectedVehicle!.truckCategory!.price,
          quantity: 1,
          totalPrice: bookingState.selectedVehicle!.truckCategory!.price,
        ),
    ];

    // Tính tổng giá trước thuế (subtotal)
    double subtotal = allSelectedServices.fold(
        0.0, (sum, service) => sum + service.totalPrice);

    // Xử lý nếu là chuyến đi khứ hồi
    if (bookingState.isRoundTrip == true) {
      subtotal *= 2;
      // Cập nhật lại totalPrice của các dịch vụ cho phù hợp
      allSelectedServices = allSelectedServices
          .map(
              (service) => service.copyWith(totalPrice: service.totalPrice * 2))
          .toList();
    }

    // Tính thuế GTGT (8% của subtotal)
    // double vat = subtotal * 0.08;

    // Thêm dịch vụ "Thuế GTGT" vào danh sách dịch vụ
    // allSelectedServices.add(ServiceItem(
    //   title: 'Thuế GTGT',
    //   unitPrice: vat,
    //   quantity: 1,
    //   totalPrice: vat,
    // ));

    // Tính tổng giá sau thuế
    double totalPrice = subtotal;

    return Container(
      color: AssetsConstants.whiteColor,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AssetsConstants.blackColor,
              ),
            ),
            const SizedBox(height: 2),
            // Hiển thị danh sách các dịch vụ
            ...allSelectedServices.map((service) => buildPriceDetailRow(
                  service.title,
                  service.totalPrice,
                  service.quantity,
                )),
            const SizedBox(height: 4),
            // Hiển thị tổng giá
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
                  formatPrice(totalPrice),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AssetsConstants.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }

  // Helper để hiển thị mỗi hàng chi tiết giá
  Widget buildPriceDetailRow(String title, double price, int quantity) {
    final priceFormat = NumberFormat('#,###', 'vi_VN');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              quantity > 1 ? '$title x$quantity' : title,
              style: const TextStyle(
                  fontSize: 14), // Tăng kích thước font cho dễ đọc
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(
            '${priceFormat.format(price)} đ',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
