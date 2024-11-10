import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_card.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/utils/commons/widgets/custom_circular.dart';
import 'package:movemate/utils/commons/widgets/empty_box.dart';
import 'package:movemate/utils/commons/widgets/home_shimmer.dart';
import 'package:movemate/utils/commons/widgets/no_more_content.dart';

// vehicle_list.dart
const checkhousetype = 'Chọn loại nhà ở';

class VehicleList extends ConsumerWidget {
  final FetchResult<InverseParentServiceEntity> fetchResult;
  final ScrollController scrollController;

  const VehicleList({
    super.key,
    required this.fetchResult,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Truy cập đến BookingNotifier và Booking thông qua các provider
    final bookingNotifier = ref.watch(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);
    final bookingStateRead = ref.read(bookingProvider);

    if (fetchResult.isFetchingData && fetchResult.items.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(child: HomeShimmer(amount: 4)),
      );
    }

    if (fetchResult.items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Align(
          alignment: Alignment.topCenter,
          child: EmptyBox(title: 'Các phương tiện đều bận'),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...fetchResult.items.map(
          (service) => GestureDetector(
            onTap: () async {
              debugPrint("Xe được chọn là: ${service.name}");
              debugPrint("Xe được chọn là: ${service.parentServiceId}");
              bookingNotifier.updateSelectedVehicle(service);
              // Gọi submitBooking và lấy kết quả
              final bookingResponse = await ref
                  .read(servicePackageControllerProvider.notifier)
                  .postValuationBooking(
                    context: context,
                  );

              print('tuan bookingEntity  bookingResponse : $bookingResponse');
              if (bookingResponse != null) {
                try {
                  // Chuyển đổi BookingResponseEntity thành Booking
                  final bookingtotal = bookingResponse.total;
                  final bookingdeposit = bookingResponse.deposit;
                  bookingNotifier.updateBookingResponse(bookingResponse);
                  print('tuan bookingEntity  total : $bookingtotal');
                  print('tuan bookingEntity  deposit : $bookingdeposit');
                  print(
                      'tuan bookingResponse: ${bookingResponse.bookingDetails.toString()}');
                  print(
                      'tuan bookingResponse: ${bookingResponse.feeDetails.toString()}');

                  // Xóa bookingState sau khi đã đăng ký thành công
                  // bookingNotifier.reset();
                } catch (e) {
                  // Xử lý ngoại lệ nếu chuyển đổi thất bại

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                  );
                }
              } else {
                // Xử lý khi bookingResponse là null
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //       content: Text('Đặt hàng thất bại. Vui lòng thử lại.')),
                // );
                // bookingNotifier
                //     .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
                if (bookingState.houseType?.name == checkhousetype) {
                  bookingNotifier
                      .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
                }
              }
              if (bookingState.houseType?.name == checkhousetype) {
                bookingNotifier
                    .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
              }
            },
            child: VehicleCard(
              service: service,
              isSelected: bookingState.selectedVehicle?.id == service.id,
            ),
          ),
        ),

        // Loading or No More Content indicator
        SizedBox(
          height: 60,
          child: Center(
            child: fetchResult.isFetchingData
                ? const CustomCircular()
                : fetchResult.isLastPage
                    ? const NoMoreContent()
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
