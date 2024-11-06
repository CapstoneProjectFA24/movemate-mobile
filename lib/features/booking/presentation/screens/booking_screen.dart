// booking_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/booking_details.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';

import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/booking_selection.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Chọn loại nhà ',
        // iconFirst: Icons.refresh_rounded,
        centerTitle: true,
        backButtonColor: AssetsConstants.whiteColor,
        // onCallBackFirst: fetchResult.refresh,
      ),
      // ignore: prefer_const_constructors
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: const Padding(
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
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final bookingState = ref.watch(bookingProvider);
          final bookingNotifier = ref.read(bookingProvider.notifier);

          return SummarySection(
            buttonIcon: false,
            buttonText: "Bước tiếp theo",
            priceLabel: "",
            isButtonEnabled: true,
            onPlacePress: () {
              if (bookingState.houseType != null &&
                  bookingState.houseType?.id != null) {
                // Validation passed, navigate to the next screen
                context.router.push(const AvailableVehiclesScreenRoute());
              } else {
                // Validation failed, set the error message
                bookingNotifier
                    .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
              }
            },
          );
        },
      ),
    );
  }
}
