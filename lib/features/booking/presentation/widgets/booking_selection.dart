import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

class BookingSelection extends HookConsumerWidget {
  const BookingSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // House Type Selection Button
        GestureDetector(
          onTap: () => _showHouseTypeModal(context, bookingNotifier),
          child: _buildSelectionButton(
            label: bookingState.houseType ?? 'Chọn loại nhà ở',
            icon: Icons.arrow_drop_down,
          ),
        ),
        const SizedBox(height: 16),

        // Room and Floor Count Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildRoomFloorCountButton(
                label: 'Số phòng ngủ',
                value: bookingState.numberOfRooms ?? 1,
                onTap: () => _showRoomCountModal(context, bookingNotifier),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('-',
                  style: TextStyle(
                      fontSize: 24, color: AssetsConstants.greyColor)),
            ),
            Expanded(
              child: _buildRoomFloorCountButton(
                label: 'Số tầng',
                value: bookingState.numberOfFloors ?? 1,
                onTap: () => _showFloorCountModal(context, bookingNotifier),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Room/Floor count button with customized style
  Widget _buildRoomFloorCountButton({
    required String label,
    required int value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AssetsConstants.greyColor
              .withOpacity(0.2), // Light grey background
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AssetsConstants.greyColor, // Grey label
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: AssetsConstants
                        .whiteColor, // White background for number
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AssetsConstants.blackColor, // Black number
                    ),
                  ),
                ),
                const SizedBox(width: 4), // Spacing between number and icon
                const Icon(Icons.arrow_drop_down,
                    color: AssetsConstants.primaryDark), // Icon color
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for selection buttons
  Widget _buildSelectionButton({
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AssetsConstants.greyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AssetsConstants.blackColor,
            ),
          ),
          Icon(icon, color: AssetsConstants.primaryDark),
        ],
      ),
    );
  }

  // House Type Modal
  void _showHouseTypeModal(
      BuildContext context, BookingNotifier bookingNotifier) {
    final List<String> houseTypes = [
      'Nhà riêng',
      'Nhà trọ',
      'Căn hộ',
      'Công ty'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn loại nhà ở',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: houseTypes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          houseTypes[index],
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                        ),
                        onTap: () {
                          bookingNotifier.updateHouseType(houseTypes[index]);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Room Count Modal
  void _showRoomCountModal(
      BuildContext context, BookingNotifier bookingNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số lượng phòng ngủ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          bookingNotifier.updateNumberOfRooms(index + 1);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Floor Count Modal
  void _showFloorCountModal(
      BuildContext context, BookingNotifier bookingNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số lượng tầng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          bookingNotifier.updateNumberOfFloors(index + 1);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
