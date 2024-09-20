// booking_select_package_screen.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';

import '../widgets/booking_screen_2th/booking_dropdown_button.dart';
import '../widgets/booking_screen_2th/package_selection.dart';
import '../widgets/booking_screen_2th/service_table.dart';
import '../widgets/booking_screen_2th/round_trip_checkbox.dart';

import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

@RoutePage()
class BookingSelectPackageScreen extends HookConsumerWidget {
  const BookingSelectPackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    void placeOrder() {
      // Implement your order placement logic here
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
                    isExpanded: bookingState.isHandlingExpanded,
                    onPressed: () {
                      bookingNotifier.toggleHandlingExpanded();
                      if (bookingState.isHandlingExpanded) {
                        bookingNotifier.setDisassemblyExpanded(false);
                      }
                    },
                  ),

                  // bug nè => run trên máy thật
                  if (bookingState.isHandlingExpanded) const PackageSelection(),
                  
                  const SizedBox(height: 16),
                  BookingDropdownButton(
                    title: 'Dịch vụ tháo lắp máy lạnh',
                    isExpanded: bookingState.isDisassemblyExpanded,
                    onPressed: () {
                      bookingNotifier.toggleDisassemblyExpanded();
                      if (bookingState.isDisassemblyExpanded) {
                        bookingNotifier.setHandlingExpanded(false);
                      }
                    },
                  ),
                  if (bookingState.isDisassemblyExpanded)
                    ServiceTable(
                      options: const ['Tháo lắp máy lạnh'],
                      prices: const ['200.000đ'],
                      selectedService: null,
                      selectedPeopleOrAirConditionersCount:
                          bookingState.airConditionersCount,
                      isThaoLapService: true,
                      onAirConditionersCountChanged: (value) {
                        bookingNotifier.updateAirConditionersCount(value ?? 1);
                        bookingNotifier.calculateAndUpdateTotalPrice();
                      },
                    ),
                  const SizedBox(height: 16),
                  RoundTripCheckbox(
                    isRoundTrip: bookingState.isRoundTrip,
                    onChanged: (value) {
                      bookingNotifier.updateRoundTrip(value ?? false);
                      bookingNotifier.calculateAndUpdateTotalPrice();
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  const ChecklistSection(),
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
              buttonText: 'Đặt đơn', // Optional customization
              priceLabel: 'Tổng giá', // Optional customization
              // priceDetailModal: CustomModal(), // Optional custom modal
            ),
          ),
        ],
      ),
    );
  }
}
