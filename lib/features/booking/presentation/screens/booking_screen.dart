// booking_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import 'package:movemate/features/booking/presentation/screens/booking_details.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/booking_selection.dart';

@RoutePage()
class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        title: "Thông tin đặt hàng",
        showBackButton: true,
        centerTitle: true,
        backButtonColor: AssetsConstants.whiteColor,
        iconSecond: Icons.home_outlined,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
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
      bottomNavigationBar: SummarySection(
        buttonIcon: false,
        buttonText: "Bước tiếp theo",
        priceLabel: "",
        isButtonEnabled: true,
        onPlacePress: () {
          context.router.push(const AvailableVehiclesScreenRoute());
        },
      ),
    );
  }
}
