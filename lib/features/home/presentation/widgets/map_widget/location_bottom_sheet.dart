import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_button.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_list.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationBottomSheet extends HookConsumerWidget {
  const LocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    // Sample list of locations
    final List<LocationModel> locations = [
      LocationModel(
        label: 'Current location',
        address: 'Your current position',
        latitude: 0.0,
        longitude: 0.0,
        distance: '',
      ),
      LocationModel(
        label: 'United States',
        address: '',
        latitude: 0.0,
        longitude: 0.0,
        distance: '',
      ),
      LocationModel(
        label: 'Office',
        address: '2972 Westheimer Rd. Santa Ana, Illinois 85486',
        latitude: 33.7454725,
        longitude: -117.867653,
        distance: '2.7km',
      ),
      LocationModel(
        label: 'Coffee shop',
        address: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
        latitude: 21.3069444,
        longitude: -157.8583333,
        distance: '1.1km',
      ),
      LocationModel(
        label: 'Shopping center',
        address: '4140 Parker Rd. Allentown, New Mexico 31134',
        latitude: 35.0844,
        longitude: -106.6504,
        distance: '4.9km',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const LabelText(
          content: 'Chọn địa chỉ',
          size: 20,
          color: AssetsConstants.blackColor,
          fontWeight: FontWeight.w400,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LocationButton(
                  label: bookingState.pickUpLocation?.label ?? 'Từ',
                  icon: Icons.my_location,
                  isSelected: bookingState.isSelectingPickUp,
                  onTap: () => bookingNotifier.toggleSelectingPickUp(true),
                ),
                const SizedBox(height: 8),
                LocationButton(
                  label: bookingState.dropOffLocation?.label ?? 'Đến',
                  icon: Icons.location_on,
                  isSelected: !bookingState.isSelectingPickUp,
                  onTap: () => bookingNotifier.toggleSelectingPickUp(false),
                ),
                const SizedBox(height: 16),
                const LabelText(
                  content: 'Địa điểm gần đây',
                  size: 16,
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Expanded(
            child: LocationList(
              locations: locations,
              onLocationSelected: (location) {
                if (bookingState.isSelectingPickUp) {
                  bookingNotifier.updatePickUpLocation(location);
                } else {
                  bookingNotifier.updateDropOffLocation(location);
                }
              },
            ),
          ),
          if (bookingState.pickUpLocation != null &&
              bookingState.dropOffLocation != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryDark,
                isButtonEnabled: true,
                onButtonPressed: () {
                  final tabsRouter = context.router.root
                      .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
                  if (tabsRouter != null) {
                    tabsRouter.setActiveIndex(0);
                    context.router
                        .popUntilRouteWithName(TabViewScreenRoute.name);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
