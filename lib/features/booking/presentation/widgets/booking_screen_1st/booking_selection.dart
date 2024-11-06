// booking_selection.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

// Import các widget
import 'selection_button.dart';
import 'room_floor_count_button.dart';
import 'number_selection_modal.dart';

// Import HouseTypeController

// Import HouseTypeSelectionModal
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/house_type/house_type_selection_modal.dart';

class BookingSelection extends HookConsumerWidget {
  const BookingSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nút chọn loại nhà ở
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectionButton(
              label: bookingState.houseType?.name ?? 'Chọn loại nhà ở',
              icon: Icons.arrow_drop_down,
              onTap: () => showHouseTypeModal(context, bookingNotifier),
            ),
            if (bookingState.houseTypeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                child: Text(
                  bookingState.houseTypeError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Nút chọn số phòng ngủ và số tầng
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RoomFloorCountButton(
                label: 'Số phòng',
                value: bookingState.numberOfRooms ?? 1,
                onTap: () => showNumberSelectionModal(
                  context,
                  title: 'Số lượng phòng',
                  maxNumber: 10,
                  onNumberSelected: (number) {
                    bookingNotifier.updateNumberOfRooms(number);
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('-',
                  style: TextStyle(
                      fontSize: 24, color: AssetsConstants.greyColor)),
            ),
            Expanded(
              child: RoomFloorCountButton(
                label: 'Số tầng',
                value: bookingState.numberOfFloors ?? 1,
                onTap: () => showNumberSelectionModal(
                  context,
                  title: 'Số lượng tầng',
                  maxNumber: 10,
                  onNumberSelected: (number) {
                    bookingNotifier.updateNumberOfFloors(number);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Phương thức hiển thị modal chọn loại nhà
  void showHouseTypeModal(
      BuildContext context, BookingNotifier bookingNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const HouseTypeSelectionModal(),
    );
  }

  // Phương thức hiển thị modal chọn số lượng
  void showNumberSelectionModal(
    BuildContext context, {
    required String title,
    required int maxNumber,
    required ValueChanged<int> onNumberSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NumberSelectionModal(
          title: title,
          maxNumber: maxNumber,
          onNumberSelected: (number) {
            onNumberSelected(number);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
