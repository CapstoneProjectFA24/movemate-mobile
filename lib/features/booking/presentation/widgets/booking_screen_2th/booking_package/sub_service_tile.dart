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
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          iconSize:
                              20, // Set the icon size as desired (default is 24)
                          onPressed: () {
                            _showDescriptionModal(
                                context, subService.description, subService);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    Center(
                      child: Container(
                        width: 30.0,
                        height: 5.0,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Circular Image at the top
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            subService.imageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Content title
                    Text(
                      subService.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Content description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    )
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
