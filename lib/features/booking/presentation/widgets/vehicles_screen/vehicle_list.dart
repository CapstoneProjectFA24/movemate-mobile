import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_card.dart';
import 'package:movemate/utils/commons/widgets/custom_circular.dart';
import 'package:movemate/utils/commons/widgets/empty_box.dart';
import 'package:movemate/utils/commons/widgets/home_shimmer.dart';
import 'package:movemate/utils/commons/widgets/no_more_content.dart';

// vehicle_list.dart
class VehicleList extends StatelessWidget {
  final dynamic state;
  final dynamic fetchResult;
  final ScrollController scrollController;
  // final ValueNotifier<ServiceEntity?> selectedService;
  final BookingNotifier bookingNotifier;
  final Booking bookingState;

  const VehicleList({
    super.key,
    required this.state,
    required this.fetchResult,
    required this.scrollController,
    // required this.selectedService,
    required this.bookingNotifier,
    required this.bookingState,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && fetchResult.items.isEmpty) {
      return const Center(child: HomeShimmer(amount: 4));
    }
    if (fetchResult.items.isEmpty) {
      return const Align(
        alignment: Alignment.topCenter,
        child: EmptyBox(title: 'Các phương tiện đều bận'),
      );
    }
    return ListView.builder(
      itemCount: fetchResult.items.length + 1,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index == fetchResult.items.length) {
          if (fetchResult.isFetchingData) {
            return const CustomCircular();
          }
          return fetchResult.isLastPage ? const NoMoreContent() : Container();
        }
        // final service = fetchResult.items[index];
        final service = fetchResult.items[index] as ServiceEntity;
        return GestureDetector(
          onTap: () {
            print("Xe được chọn là: ${service.name}");
            print("Xe được chọn là: ${service.id}");
            print("Xe được chọn là: ${service.truckCategory?.id}");
            // selectedService.value = service;
            bookingNotifier.updateSelectedVehicle(service);
          },
          child: VehicleCard(
            service: service,
            // isSelected: selectedService.value?.id == service.id,
            isSelected: bookingState.selectedVehicle?.truckCategory?.id ==
                service.truckCategory?.id,
          ),
        );
      },
    );
  }
}
