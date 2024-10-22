import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import this for HookConsumerWidget
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';

import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/screens/location_selection_screen.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceSelector extends HookConsumerWidget {
  const ServiceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    // Create a TextEditingController using Hook
    final dateController = useTextEditingController();

    // Function to format DateTime
    String formatDateTime(DateTime dateTime) {
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    // Use useEffect to update the controller text whenever bookingDate changes
    useEffect(() {
      if (bookingState.bookingDate != null) {
        dateController.text = formatDateTime(bookingState.bookingDate!);
      } else {
        dateController.text = 'Chọn ngày';
      }
      return null; // Return null since no cleanup is needed
    }, [bookingState.bookingDate]);

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
            FadeInLeft(
              child: Container(
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
            ),
            const SizedBox(height: 16),

            // Label cho mục "Từ"
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Từ',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            buildLocationSelection(context, bookingState.pickUpLocation, () {
              bookingNotifier.toggleSelectingPickUp(true);
              navigateToLocationSelectionScreen(context);
            }),

            const SizedBox(height: 16),

            // Label cho mục "Đến"
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Đến',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            buildLocationSelection(
              context,
              bookingState.dropOffLocation,
              () {
                bookingNotifier.toggleSelectingPickUp(false);
                navigateToLocationSelectionScreen(context);
              },
            ),

            const SizedBox(height: 16),

            // Label cho mục "Ngày"
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Ngày',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                final selectedDate =
                    await selectDate(context, bookingState.bookingDate);
                if (selectedDate != null) {
                  bookingNotifier.updateBookingDate(selectedDate);
                }
              },
              child: AbsorbPointer(
                child: FadeInRight(
                  child: TextFormField(
                    controller: dateController, // Use the controller here
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AssetsConstants.whiteColor,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    style: const TextStyle(color: AssetsConstants.blackColor),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Kiểm tra điều kiện trước khi điều hướng
            FadeInRight(
              child: ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryMain,
                isButtonEnabled: true, // Cho phép luôn hiển thị nút
                onButtonPressed: () {
                  // Điều kiện kiểm tra xem cả 2 giá trị pickUpLocation và dropOffLocation có tồn tại không
                  if (bookingState.pickUpLocation != null &&
                      bookingState.dropOffLocation != null) {
                    context.router.push(const BookingScreenRoute());
                    print(
                        "Pick-up location: ${bookingState.pickUpLocation?.address} ");
                    print(
                        "Drop-off location: ${bookingState.dropOffLocation?.address} ");
                    print(
                        "Drop-off location latitude: ${bookingState.dropOffLocation?.latitude} ");
                    print(
                        "Drop-off location longitude: ${bookingState.dropOffLocation?.longitude} ");
                  } else {
                    // Hiển thị cảnh báo hoặc thông báo người dùng chọn cả hai địa điểm
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Vui lòng chọn đầy đủ địa điểm Từ và Đến"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocationSelection(
    BuildContext context,
    LocationModel? location,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: FadeInRight(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AssetsConstants.primaryMain),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(
                Icons.add_location_outlined,
                color: AssetsConstants.primaryMain,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location?.address ?? 'Chọn địa điểm',
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm để điều hướng đến màn hình chọn địa điểm
  void navigateToLocationSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSelectionScreen(),
      ),
    );
  }

  // Hàm để hiển thị modal ngày và chọn giờ
  Future<DateTime?> selectDate(
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
