// vehicle_list.dart
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

// vehicle_list.dart// vehicle_list.dart
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
    final bookingNotifier = ref.watch(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

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
          (service) => VehicleCard(
            service: service,
            isSelected: bookingState.selectedVehicle?.id == service.id,
            onTap: () async {
              debugPrint("Xe được chọn là: ${service.name}");
              debugPrint("Xe được chọn là: ${service.parentServiceId}");

              if (bookingState.selectedVehicle?.id == service.id) {
                // Nếu xe đã được chọn trước đó, gọi hàm resetVehiclesSelected()
                bookingNotifier.resetVehiclesSelected(null);
              } else {
                // Nếu xe chưa được chọn, gọi hàm updateSelectedVehicle()
                bookingNotifier.updateSelectedVehicle(service);
              }

              final bookingResponse = await ref
                  .read(servicePackageControllerProvider.notifier)
                  .postValuationBooking(
                    context: context,
                  );

              if (bookingResponse != null) {
                try {
                  bookingNotifier.updateBookingResponse(bookingResponse);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                  );
                }
              }
              if (bookingState.houseType?.name == checkhousetype ||
                  bookingState.houseType?.name == null) {
                bookingNotifier
                    .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
              }
            },
          ),
        ),
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
