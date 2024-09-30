// Widget cho modal chọn địa điểm
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/widgets/button_custom.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationSelectionModal extends HookConsumerWidget {
  final WidgetRef ref;

  LocationSelectionModal({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
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
                _buildLocationButton(
                  context,
                  label: bookingState.pickUpLocation?.label ?? 'Từ',
                  icon: Icons.my_location,
                  isSelected: bookingState.isSelectingPickUp,
                  onTap: () => bookingNotifier.toggleSelectingPickUp(true),
                ),
                const SizedBox(height: 8),
                _buildLocationButton(
                  context,
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
          // List of locations
          Expanded(
            child: ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                return _buildLocationOption(
                  context,
                  location: location,
                  onTap: () {
                    if (bookingState.isSelectingPickUp) {
                      bookingNotifier.updatePickUpLocation(location);
                    } else {
                      bookingNotifier.updateDropOffLocation(location);
                    }
                  },
                );
              },
            ),
          ),
          if (bookingState.pickUpLocation != null &&
              bookingState.pickUpLocation != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryDark,
                isButtonEnabled: true,
                onButtonPressed: () => {
                  context.router.push(const HomeScreenRoute()),
                  print("object1  ${bookingState.pickUpLocation?.address} "),
                  print("object2  ${bookingState.dropOffLocation?.address} "),
                },
              ),
            ),
        ],
      ),
    );
  }

  // Sample list of locations
  final List<LocationModel> _locations = [
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

  Widget _buildLocationButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AssetsConstants.green1
                  : AssetsConstants.greyColor.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? AssetsConstants.green1.withOpacity(0.1)
                : AssetsConstants.whiteColor,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? AssetsConstants.green1
                    : AssetsConstants.greyColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AssetsConstants.green1
                        : AssetsConstants.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption(
    BuildContext context, {
    required LocationModel location,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          const Icon(Icons.location_on, color: AssetsConstants.primaryDark),
      title: LabelText(
        content: location.label,
        size: 16,
        color: AssetsConstants.blackColor,
        fontWeight: FontWeight.w400,
      ),
      subtitle: LabelText(
        content: location.address,
        size: 12,
        color: AssetsConstants.greyColor,
        fontWeight: FontWeight.w400,
      ),
      trailing: LabelText(
        content: location.distance,
        size: 12,
        fontWeight: FontWeight.w400,
      ),
      onTap: onTap,
    );
  }
}
