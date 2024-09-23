import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';

import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/screens/location_selection_screen.dart';
import 'package:movemate/features/home/presentation/widgets/button_custom.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceSelector extends HookConsumerWidget {
  const ServiceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Card(
      color: AssetsConstants.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(top: 100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: AssetsConstants.primaryLighter,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: LabelText(
                  content: 'Số dư 0 đ',
                  size: 18,
                  fontWeight: FontWeight.w700,
                  color: AssetsConstants.whiteColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Label cho mục "Từ"
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: LabelText(
                content: 'Từ',
                size: 16,
                fontFamily: 'bold',
                color: AssetsConstants.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            _buildLocationSelection(context, bookingState.pickUpLocation, () {
              bookingNotifier.toggleSelectingPickUp(true);
              _navigateToLocationSelectionScreen(context);
            }),

            const SizedBox(height: 16),

            // Label cho mục "Đến"
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: LabelText(
                content: 'Đến',
                size: 16,
                fontFamily: 'bold',
                color: AssetsConstants.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            _buildLocationSelection(
              context,
              bookingState.dropOffLocation,
              () {
                bookingNotifier.toggleSelectingPickUp(false);
                _navigateToLocationSelectionScreen(context);
              },
            ),

            const SizedBox(height: 16),

            // Label cho mục "Ngày"
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: LabelText(
                content: 'Ngày',
                size: 16,
                fontFamily: 'bold',
                color: AssetsConstants.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                final selectedDate =
                    await _selectDate(context, bookingState.bookingDate);
                if (selectedDate != null) {
                  bookingNotifier.updateBookingDate(selectedDate);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AssetsConstants.whiteColor,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  initialValue: bookingState.bookingDate != null
                      ? '${bookingState.bookingDate!.year}/${bookingState.bookingDate!.month.toString().padLeft(2, '0')}/${bookingState.bookingDate!.day.toString().padLeft(2, '0')} - ${bookingState.bookingDate!.hour.toString().padLeft(2, '0')}:${bookingState.bookingDate!.minute.toString().padLeft(2, '0')}'
                      : 'Chọn ngày',
                  style: const TextStyle(color: AssetsConstants.blackColor),
                ),
              ),
            ),

            // Kiểm tra điều kiện trước khi điều hướng
            if (bookingState.pickUpLocation != null &&
                bookingState.dropOffLocation != null)
              ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryMain,
                isButtonEnabled: true,
                onButtonPressed: () => {
                  context.router.push(const BookingScreenRoute()),
                  print("object1  ${bookingState.pickUpLocation?.address} "),
                  print("object2  ${bookingState.dropOffLocation?.address} "),
                },
              ),
          ],
        ),
      ),
    );
  }

  // Widget để hiển thị lựa chọn địa điểm
  Widget _buildLocationSelection(
    BuildContext context,
    LocationModel? location,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AssetsConstants.primaryMain),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.add_location_outlined,
                color: AssetsConstants.primaryMain, size: 20),
            const SizedBox(width: 8),
            Text(
              location?.label ?? 'Chọn địa điểm',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để điều hướng đến màn hình chọn địa điểm
  void _navigateToLocationSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSelectionScreen(),
      ),
    );
  }

  //hàm để hiển thị model ngày và chọn giờ
  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: initialDate != null
            ? TimeOfDay(hour: initialDate.hour, minute: initialDate.minute)
            : TimeOfDay.now(),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
    return null;
  }
}
