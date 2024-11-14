import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class SubServiceTile extends ConsumerWidget {
  final SubServiceEntity subService;

  const SubServiceTile({super.key, required this.subService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    final currentSubService = bookingState.selectedSubServices.firstWhere(
      (s) => s.id == subService.id,
      orElse: () => subService.copyWith(quantity: 0),
    );

    final int quantity = currentSubService.quantity ?? 0;

    return Card(
      color: AssetsConstants.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần nội dung chính (Tên và mô tả)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên dịch vụ và nút thông tin
                    Row(
                      children: [
                        // Expanded cho Text để tránh overflow
                        Expanded(
                          child: Text(
                            subService.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Nút Icon thông tin
                        IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          onPressed: () {
                            _showDescriptionModal(
                                context, subService.description, subService);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Mô tả dịch vụ
                    Text(
                      subService.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Phần trailing (IconButton và ServiceTrailingWidget)
              // Sử dụng SizedBox để giới hạn chiều rộng tối đa
              SizedBox(
                width: 120, // Điều chỉnh giá trị này theo nhu cầu
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Nút Icon thông tin (nếu cần)
                    // Nếu bạn chỉ có một IconButton, hãy đảm bảo nó không bị trùng lặp
                    // Nếu không cần, có thể loại bỏ phần này
                    // IconButton(
                    //   icon: const Icon(Icons.info_outline, color: Colors.blue),
                    //   onPressed: () {
                    //     _showDescriptionModal(context, subService.description);
                    //   },
                    // ),
                    // ServiceTrailingWidget
                    ServiceTrailingWidget(
                      quantity: quantity,
                      addService: !subService.isQuantity,
                      quantityMax: subService.quantityMax,
                      onQuantityChanged: (newQuantity) async {
                        bookingNotifier.updateSubServiceQuantity(
                            subService, newQuantity);
                        bookingNotifier.calculateAndUpdateTotalPrice();

                        // Gọi submitBooking và lấy kết quả
                        final bookingResponse = await ref
                            .read(servicePackageControllerProvider.notifier)
                            .postValuationBooking(
                              context: context,
                            );

                        if (bookingResponse != null) {
                          try {
                            final bookingtotal = bookingResponse.total;
                            final bookingdeposit = bookingResponse.deposit;
                            bookingNotifier
                                .updateBookingResponse(bookingResponse);
                            print('tuan bookingEntity  total : $bookingtotal');
                            print(
                                'tuan bookingEntity  deposit : $bookingdeposit');
                            print(
                                'tuan bookingResponse: ${bookingResponse.bookingDetails.toString()}');
                            print(
                                'tuan bookingResponse: ${bookingResponse.feeDetails.toString()}');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Đặt hàng thất bại. Vui lòng thử lại.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm hiển thị modal với mô tả
  void _showDescriptionModal(
      BuildContext context, String description, SubServiceEntity subService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép modal cuộn đầy đủ màn hình
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mô tả Dịch vụ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Nội dung mô tả
                    Text(
                      subService.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Nội dung mô tả
                    Text(
                      subService.type,
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Nội dung mô tả
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
