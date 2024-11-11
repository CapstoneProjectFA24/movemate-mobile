// service_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/balance_indicator.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/location_field.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/date_time_section.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/confirmation_button.dart';
import 'package:movemate/features/home/presentation/screens/location_selection_screen.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceSelector extends HookConsumerWidget {
  const ServiceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final showErrors = useState(false);

    final isDateTimeInvalid = useState(false);

    final pickUpController = useTextEditingController(text: 'Chọn địa điểm');
    final dropOffController = useTextEditingController(text: 'Chọn địa điểm');

    final dateController = useTextEditingController(text: 'Chọn ngày và giờ');

    final pickUpFocusNode = useFocusNode();
    final dropOffFocusNode = useFocusNode();
    final dateFocusNode = useFocusNode();

    String formatDateTime(DateTime dateTime) {
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    void validateDateTime() {
      if (bookingState.bookingDate != null) {
        isDateTimeInvalid.value =
            bookingState.bookingDate!.isBefore(DateTime.now());
      } else {
        isDateTimeInvalid.value = true;
      }
    }

    void navigateToLocationSelectionScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationSelectionScreen(),
        ),
      );
    }

    Future<DateTime?> selectDate(DateTime? initialDate) async {
      final now = DateTime.now();

      final defaultTime =
          TimeOfDay(hour: (now.hour + 1) % 24, minute: now.minute);

      final lastDate = now.add(const Duration(days: 30));

      final selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? now,
        firstDate: now,
        lastDate: lastDate,
        selectableDayPredicate: (DateTime date) {
          return date.difference(now).inDays <= 30;
        },
      );
      if (selectedDate != null) {
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

    useEffect(() {
      validateDateTime();
      return null;
    }, [bookingState.bookingDate]);

    useEffect(() {
      if (bookingState.bookingDate != null) {
        dateController.text = formatDateTime(bookingState.bookingDate!);
      } else {
        dateController.text = 'Chọn ngày và giờ';
      }
      print("DateController updated to: ${dateController.text}");
      return null;
    }, [bookingState.bookingDate]);

    useEffect(() {
      if (bookingState.pickUpLocation != null &&
          bookingState.pickUpLocation!.address != 'Chọn địa điểm') {
        pickUpController.text = bookingState.pickUpLocation!.address;
      } else {
        pickUpController.text = 'Chọn địa điểm';
      }
      print("PickUpController updated to: ${pickUpController.text}");
      return null;
    }, [bookingState.pickUpLocation]);

    useEffect(() {
      if (bookingState.dropOffLocation != null &&
          bookingState.dropOffLocation!.address != 'Chọn địa điểm') {
        dropOffController.text = bookingState.dropOffLocation!.address;
      } else {
        dropOffController.text = 'Chọn địa điểm';
      }
      print("DropOffController updated to: ${dropOffController.text}");
      return null;
    }, [bookingState.dropOffLocation]);

    useEffect(() {
      void listener() {
        if (showErrors.value) {
          final isPickUpValid = bookingState.pickUpLocation != null &&
              bookingState.pickUpLocation!.address != 'Chọn địa điểm';
          final isDropOffValid = bookingState.dropOffLocation != null &&
              bookingState.dropOffLocation!.address != 'Chọn địa điểm';
          final isDateValid =
              bookingState.bookingDate != null && !isDateTimeInvalid.value;

          if (isPickUpValid && isDropOffValid && isDateValid) {
            showErrors.value = false;
          }
        }
      }

      listener();

      return null;
    }, [
      bookingState.pickUpLocation,
      bookingState.dropOffLocation,
      bookingState.bookingDate,
      isDateTimeInvalid.value
    ]);

    useEffect(() {
      void onFocusChange() {
        if (!pickUpFocusNode.hasFocus &&
            !dropOffFocusNode.hasFocus &&
            !dateFocusNode.hasFocus) {
          final isPickUpValid = bookingState.pickUpLocation != null &&
              bookingState.pickUpLocation!.address != 'Chọn địa điểm';
          final isDropOffValid = bookingState.dropOffLocation != null &&
              bookingState.dropOffLocation!.address != 'Chọn địa điểm';
          final isDateValid =
              bookingState.bookingDate != null && !isDateTimeInvalid.value;

          if (isPickUpValid && isDropOffValid && isDateValid) {
            showErrors.value = false;
          }
        }
      }

      pickUpFocusNode.addListener(onFocusChange);
      dropOffFocusNode.addListener(onFocusChange);
      dateFocusNode.addListener(onFocusChange);

      return () {
        pickUpFocusNode.removeListener(onFocusChange);
        dropOffFocusNode.removeListener(onFocusChange);
        dateFocusNode.removeListener(onFocusChange);
      };
    }, [
      bookingState.pickUpLocation,
      bookingState.dropOffLocation,
      bookingState.bookingDate,
      isDateTimeInvalid.value
    ]);

    return Card(
      color: AssetsConstants.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(top: 100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BalanceIndicator(),
              const SizedBox(height: 16),

              // LocationField for Pick-Up Location
              LocationField(
                locationController: pickUpController,
                title: 'Địa điểm bắt đầu',
                location: bookingState.pickUpLocation,
                onTap: () {
                  bookingNotifier.toggleSelectingPickUp(true);
                  navigateToLocationSelectionScreen();
                },
                hasError: showErrors.value &&
                    (bookingState.pickUpLocation == null ||
                        bookingState.pickUpLocation!.address ==
                            'Chọn địa điểm'),
                errorMessage: 'Vui lòng chọn điểm bắt đầu',
                onClear: () {
                  bookingNotifier.clearPickUpLocation();
                  // The controller text will be updated via useEffect
                },
              ),
              const SizedBox(height: 16),

              // LocationField for Drop-Off Location
              LocationField(
                locationController: dropOffController,
                title: 'Địa điểm kết thúc',
                location: bookingState.dropOffLocation,
                onTap: () {
                  bookingNotifier.toggleSelectingPickUp(false);
                  navigateToLocationSelectionScreen();
                },
                hasError: showErrors.value &&
                    (bookingState.dropOffLocation == null ||
                        bookingState.dropOffLocation!.address ==
                            'Chọn địa điểm'),
                errorMessage: 'Vui lòng chọn điểm kết thúc',
                onClear: () {
                  bookingNotifier.clearDropOffLocation();
                  // The controller text will be updated via useEffect
                },
              ),
              const SizedBox(height: 16),

              // DateTimeSection for Booking Date and Time
              DateTimeSection(
                controller: dateController,
                showErrors: showErrors.value,
                isDateTimeInvalid: isDateTimeInvalid.value,
                onTap: () async {
                  final selectedDate =
                      await selectDate(bookingState.bookingDate);
                  if (selectedDate != null) {
                    bookingNotifier.updateBookingDate(selectedDate);
                  }
                },
                onClear: () {
                  bookingNotifier.clearBookingDate();
                  // The controller text will be updated via useEffect
                },
                focusNode: dateFocusNode,
              ),
              const SizedBox(height: 16),

              // ConfirmationButton to proceed
              ConfirmationButton(
                onPressed: () {
                  showErrors.value = true; // Show validation errors

                  // bookingNotifier.updatePickUpLocation(LocationModel(
                  //     label: 'label',
                  //     address:
                  //         'Nhà Văn Hoá Sinh Viên, university, Dĩ An, Vietnam',
                  //     latitude: 10.8753395,
                  //     longitude: 106.8000331,
                  //     distance: "43"));
                  // bookingNotifier.updateDropOffLocation(
                  //   LocationModel(
                  //       label: 'label',
                  //       address:
                  //           'FPT University - HCMC Campus, university, Ho Chi Minh City, Vietnam',
                  //       latitude: 10.841416800000001,
                  //       longitude: 106.81007447258705,
                  //       distance: '2'),
                  // );

                  // bookingNotifier.updateBookingDate(
                  //     DateTime.now().add(const Duration(days: 1)));
                  // Validate booking details
                  final isPickUpValid = bookingState.pickUpLocation != null &&
                      bookingState.pickUpLocation!.address != 'Chọn địa điểm';
                  final isDropOffValid = bookingState.dropOffLocation != null &&
                      bookingState.dropOffLocation!.address != 'Chọn địa điểm';
                  final isDateValid = bookingState.bookingDate != null &&
                      !isDateTimeInvalid.value;

                  final isPickUpSelected =
                      bookingState.pickUpLocation?.address != 'Chọn địa điểm';
                  final isDropOffSelected =
                      bookingState.dropOffLocation?.address != 'Chọn địa điểm';
                  final isDateSelected =
                      dateController.text != 'Chọn ngày và giờ';

                  print(
                      "Pick-up location: ${bookingState.pickUpLocation?.address ?? 'Not selected'}");
                  print(
                      "Drop-off location: ${bookingState.dropOffLocation?.address ?? 'Not selected'}");
                  print(
                      "Drop-off location latitude: ${bookingState.dropOffLocation?.latitude}");
                  print(
                      "Drop-off location longitude: ${bookingState.dropOffLocation?.longitude}");
                  if (bookingState.bookingDate != null) {
                    print(
                        "Booking date: ${formatDateTime(bookingState.bookingDate!)}");
                  }
                  print("isDateTimeInvalid: ${!isDateTimeInvalid.value}");

                  if (isPickUpValid &&
                      isDropOffValid &&
                      isDateValid &&
                      isPickUpSelected &&
                      isDropOffSelected &&
                      isDateSelected) {
                    context.router.push(const BookingScreenRoute());
                    // Print booking details (optional)
                    print(
                        "Pick-up location: ${bookingState.pickUpLocation!.address}");
                    print(
                        "Drop-off location: ${bookingState.dropOffLocation!.address}");
                    print(
                        "Drop-off location latitude: ${bookingState.dropOffLocation?.latitude}");
                    print(
                        "Drop-off location longitude: ${bookingState.dropOffLocation?.longitude}");
                    print(
                        "Booking date: ${formatDateTime(bookingState.bookingDate!)}");
                    print("isDateTimeInvalid: ${!isDateTimeInvalid.value}");
                  } else {
                    // Do nothing, validation errors are already displayed
                    print(
                        "Please fill in all the required information before proceeding.");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
