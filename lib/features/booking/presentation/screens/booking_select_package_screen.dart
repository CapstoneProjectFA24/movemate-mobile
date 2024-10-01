// booking_select_package_screen.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

@RoutePage()
class BookingSelectPackageScreen extends HookConsumerWidget {
  const BookingSelectPackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    placeOder() {
      return;
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
                  const SizedBox(height: 8),
                  const PackageSelection(),
                  const SizedBox(height: 16),
                  // Add more widgets for extra services like 'Phí chờ', etc.

                  const SizedBox(height: 16),
                  RoundTripCheckbox(
                    isRoundTrip: bookingState.isRoundTrip,
                    onChanged: (value) {
                      bookingNotifier.updateRoundTrip(value ?? false);
                      bookingNotifier.calculateAndUpdateTotalPrice();
                    },
                  ),

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
              buttonIcon: true,
              totalPrice: bookingState.totalPrice,
              isButtonEnabled: true,
              onPlacePress: () {},
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
