import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_card.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/utils/commons/widgets/custom_circular.dart';
import 'package:movemate/utils/commons/widgets/empty_box.dart';
import 'package:movemate/utils/commons/widgets/home_shimmer.dart';
import 'package:movemate/utils/commons/widgets/no_more_content.dart';

// vehicle_list.dart
class VehicleList extends StatelessWidget {
  final FetchResult<InverseParentServiceEntity> fetchResult;
  final ScrollController scrollController;
  final BookingNotifier bookingNotifier;
  final Booking bookingState;

  const VehicleList({
    super.key,
    required this.fetchResult,
    required this.scrollController,
    required this.bookingNotifier,
    required this.bookingState,
  });

  @override
  Widget build(BuildContext context) {
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
        ...fetchResult.items.map((service) => GestureDetector(
              onTap: () {
                debugPrint("Xe được chọn là: ${service.name}");
                debugPrint("Xe được chọn là: ${service.parentServiceId}");
                bookingNotifier.updateSelectedVehicle(service);
              },
              child: VehicleCard(
                service: service,
                isSelected: bookingState.selectedVehicle?.id == service.id,
              ),
            )),

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
