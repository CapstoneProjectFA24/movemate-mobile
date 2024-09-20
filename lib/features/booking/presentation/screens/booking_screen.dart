// booking_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/booking_details.dart';

import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/total_price_section.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_selection.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đặt hàng'),
        backgroundColor: AssetsConstants.mainColor,
      ),
      body: const SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: 100), // Ensure content is above the button
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              BookingSelection(),
              SizedBox(height: 16),
              BookingDetails(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TotalPriceSection(
        totalPrice: bookingState.totalPrice,
        isButtonEnabled: true, // Assuming the button is always enabled here
        onButtonPressed: () {
          context.router.push(const AvailableVehiclesScreenRoute());
        },
      ),
    );
  }
}
