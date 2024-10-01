import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

// Import cắc widget
import 'selection_button.dart';
import 'room_floor_count_button.dart';
import 'selection_modal.dart';
import 'number_selection_modal.dart';

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
        SelectionButton(
          label: bookingState.houseType ?? 'Chọn loại nhà ở',
          icon: Icons.arrow_drop_down,
          onTap: () => _showHouseTypeModal(context, bookingNotifier),
        ),
        const SizedBox(height: 16),
        // Nút chọn số phòng ngủ và số tầng
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RoomFloorCountButton(
                label: 'Số phòng ngủ',
                value: bookingState.numberOfRooms ?? 1,
                onTap: () => _showNumberSelectionModal(
                  context,
                  title: 'Số lượng phòng ngủ',
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
                onTap: () => _showNumberSelectionModal(
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
  void _showHouseTypeModal(
      BuildContext context, BookingNotifier bookingNotifier) {
    final List<String> houseTypes = [
      'Nhà riêng',
      'Nhà trọ',
      'Căn hộ',
      'Công ty',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectionModal(
          title: 'Chọn loại nhà ở',
          items: houseTypes,
          onItemSelected: (selectedItem) {
            bookingNotifier.updateHouseType(selectedItem);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Phương thức hiển thị modal chọn số lượng
  void _showNumberSelectionModal(
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
