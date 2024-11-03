import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    // Add state for showing validation errors
    final showErrors = useState(false);

    // Add state for invalid datetime error
    final isDateTimeInvalid = useState(false);

    // Function to check if selected datetime is valid
    void validateDateTime() {
      if (bookingState.bookingDate != null) {
        isDateTimeInvalid.value =
            bookingState.bookingDate!.isBefore(DateTime.now());
      } else {
        isDateTimeInvalid.value = false;
      }
    }

    // Validate datetime whenever it changes
    useEffect(() {
      validateDateTime();
      return null;
    }, [bookingState.bookingDate]);

    final dateController = useTextEditingController();

    String formatDateTime(DateTime dateTime) {
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    useEffect(() {
      if (bookingState.bookingDate != null) {
        dateController.text = formatDateTime(bookingState.bookingDate!);
      } else {
        dateController.text = 'Chọn ngày - giờ';
      }
      return null;
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
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                decoration: BoxDecoration(
                  color: AssetsConstants.primaryLighter,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: LabelText(
                    content: 'Số dư 0 đ',
                    size: 14,
                    fontWeight: FontWeight.w600,
                    color: AssetsConstants.whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pickup Location Section
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Địa điểm bắt đầu',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLocationSelection(
                  context,
                  bookingState.pickUpLocation,
                  () {
                    bookingNotifier.toggleSelectingPickUp(true);
                    navigateToLocationSelectionScreen(context);
                  },
                  showErrors.value && bookingState.pickUpLocation == null,
                ),
                if (showErrors.value && bookingState.pickUpLocation == null)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      'Vui lòng chọn điểm bắt đầu',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Dropoff Location Section
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Địa điểm kết thúc',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLocationSelection(
                  context,
                  bookingState.dropOffLocation,
                  () {
                    bookingNotifier.toggleSelectingPickUp(false);
                    navigateToLocationSelectionScreen(context);
                  },
                  showErrors.value && bookingState.dropOffLocation == null,
                ),
                if (showErrors.value && bookingState.dropOffLocation == null)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      'Vui lòng chọn điểm kết thúc',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Date Time Section
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeInUp(
                child: const LabelText(
                  content: 'Ngày và giờ',
                  size: 16,
                  fontFamily: 'bold',
                  color: AssetsConstants.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        controller: dateController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AssetsConstants.whiteColor,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: showErrors.value &&
                                      (bookingState.bookingDate == null ||
                                          isDateTimeInvalid.value)
                                  ? Colors.red
                                  : AssetsConstants.primaryMain,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: showErrors.value &&
                                      (bookingState.bookingDate == null ||
                                          isDateTimeInvalid.value)
                                  ? Colors.red
                                  : AssetsConstants.primaryMain,
                            ),
                          ),
                        ),
                        style:
                            const TextStyle(color: AssetsConstants.blackColor),
                      ),
                    ),
                  ),
                ),
                if (showErrors.value &&
                    (bookingState.bookingDate == null ||
                        isDateTimeInvalid.value))
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      isDateTimeInvalid.value
                          ? 'Vui lòng chọn thời gian sau thời điểm hiện tại'
                          : 'Vui lòng chọn thời gian',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Button Section
            FadeInRight(
              child: ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryMain,
                isButtonEnabled: true,
                onButtonPressed: () {
                  showErrors.value = true; // Show validation errors

                  if (bookingState.pickUpLocation != null &&
                      bookingState.dropOffLocation != null &&
                      bookingState.bookingDate != null &&
                      !isDateTimeInvalid.value) {
                    context.router.push(const BookingScreenRoute());
                    print(
                        "Pick-up location: ${bookingState.pickUpLocation?.address} ");
                    print(
                        "Drop-off location: ${bookingState.dropOffLocation?.address} ");
                    print(
                        "Drop-off location latitude: ${bookingState.dropOffLocation?.latitude} ");
                    print(
                        "Drop-off location longitude: ${bookingState.dropOffLocation?.longitude} ");
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
    bool hasError,
  ) {
    return InkWell(
      onTap: onTap,
      child: FadeInRight(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : AssetsConstants.primaryMain,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.add_location_outlined,
                color: hasError ? Colors.red : AssetsConstants.primaryMain,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location?.address ?? 'Chọn địa điểm',
                  style: TextStyle(
                    fontSize: 16,
                    color: hasError ? Colors.red : AssetsConstants.blackColor,
                  ),
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

  void navigateToLocationSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSelectionScreen(),
      ),
    );
  }

  Future<DateTime?> selectDate(
      BuildContext context, DateTime? initialDate) async {
    final now = DateTime.now();

    // Tạo thời gian mặc định là giờ hiện tại + 1
    final defaultTime = TimeOfDay(
        hour: (now.hour + 1) % 24, // Đảm bảo giờ không vượt quá 24
        minute: now.minute);

    // Thiết lập ngày cuối cùng có thể chọn (30 ngày từ hiện tại)
    final lastDate = now.add(const Duration(days: 30));

    // Hiển thị date picker với range giới hạn 30 ngày
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: now,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime date) {
        // Chỉ cho phép chọn trong vòng 30 ngày
        return date.difference(now).inDays <= 30;
      },
    );
    if (selectedDate != null) {
      // Hiển thị time picker với giờ mặc định là giờ hiện tại + 1
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: initialDate != null
            ? TimeOfDay(hour: initialDate.hour, minute: initialDate.minute)
            : defaultTime,
      );

      if (selectedTime != null) {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        return selectedDateTime;
      }
    }
    return null;
  }
}
