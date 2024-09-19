import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:auto_route/auto_route.dart';

import '../widgets/booking_screen_2th/export_booking_screen_2th.dart';

import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

@RoutePage()
class BookingSelectPackageScreen extends HookConsumerWidget {
  const BookingSelectPackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management using hooks
    final isBocXepExpanded = useState(false);
    final isThaoLapExpanded = useState(false);
    final noteController = useTextEditingController();

    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final packageData = ref.watch(packageDataProvider);
    final thaoLapServices = ref.watch(thaoLapServicesProvider);
    final checklistOptions = ref.watch(checklistOptionsProvider);
    final checklistValues = ref.watch(checklistDataProvider);

    final packageSelected = useState<List<bool>>(
      List<bool>.filled(packageData['packageTitles'].length, false),
    );

    void updateTotalPrice() {
      double basePrice = 1794.000;
      if (bookingState.isRoundTrip) {
        basePrice *= 1.7;
      }

      for (int i = 0; i < packageSelected.value.length; i++) {
        if (packageSelected.value[i]) {
          switch (i) {
            case 0:
              basePrice += 730.000;
              break;
            case 1:
              basePrice += 660.000;
              break;
            case 2:
              basePrice += 120.000;
              break;
          }
        }
      }

      bookingNotifier.updateTotalPrice(basePrice);
    }

    void placeOrder() {
      final notes = noteController.text;
      bookingNotifier.updateNotes(notes);
      // Add your API call here
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đặt hàng'),
        backgroundColor: AssetsConstants.primaryMain,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingDropdownButton(
                    title: 'Dịch vụ bốc xếp',
                    isExpanded: isBocXepExpanded.value,
                    onPressed: () {
                      isBocXepExpanded.value = !isBocXepExpanded.value;
                      isThaoLapExpanded.value = false;
                    },
                  ),
                  if (isBocXepExpanded.value)
                    PackageSelection(
                      selectedPackageIndex: bookingState.selectedPackageIndex,
                      selectedPeopleCount: 1,
                      onPeopleCountChanged: (value) {},
                      onChanged: (index) {
                        packageSelected.value[index] =
                            !packageSelected.value[index];
                        bookingNotifier.updateSelectedPackageIndex(index);
                        updateTotalPrice();
                      },
                    ),
                  const SizedBox(height: 16),
                  BookingDropdownButton(
                    title: 'Dịch vụ tháo lắp máy lạnh',
                    isExpanded: isThaoLapExpanded.value,
                    onPressed: () {
                      isThaoLapExpanded.value = !isThaoLapExpanded.value;
                      isBocXepExpanded.value = false;
                    },
                  ),
                  if (isThaoLapExpanded.value)
                    ServiceTable(
                      options: thaoLapServices
                          .map((e) => e['service'] as String)
                          .toList(),
                      prices: thaoLapServices
                          .map((e) => e['price'] as String)
                          .toList(),
                      selectedService: null,
                      selectedPeopleOrAirConditionersCount:
                          bookingState.airConditionersCount,
                      isThaoLapService: true,
                      onAirConditionersCountChanged: (value) {
                        bookingNotifier.updateAirConditionersCount(value ?? 1);
                      },
                    ),
                  const SizedBox(height: 16),
                  RoundTripCheckbox(
                    isRoundTrip: bookingState.isRoundTrip,
                    onChanged: (value) {
                      bookingNotifier.updateRoundTrip(value ?? false);
                      updateTotalPrice();
                    },
                  ),
                  const SizedBox(height: 16),
                  ChecklistSection(
                    checklistOptions: checklistOptions,
                    checklistValues: checklistValues,
                    onChanged: (index) {
                      ref
                          .read(checklistDataProvider.notifier)
                          .toggleValue(index);
                    },
                  ),
                  const SizedBox(height: 16),
                  const NotesSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SummarySection(
              totalPrice: bookingState.totalPrice,
              onPlaceOrder: placeOrder,
            ),
          ),
        ],
      ),
    );
  }
}
