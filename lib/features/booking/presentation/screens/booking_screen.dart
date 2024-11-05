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
      bottomNavigationBar: SummarySection(
        buttonIcon: false,
        buttonText: "Bước tiếp theo",
        priceLabel: "",
        isButtonEnabled: true,
        onPlacePress: () {
          if (bookingState.houseType != null &&
              bookingState.houseType?.id != null) {
            context.router.push(const AvailableVehiclesScreenRoute());
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  clipBehavior:
                      Clip.none, // Cho phép widget con vượt ra ngoài Stack
                  children: [
                    AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 60,
                            height: 30,
                            // decoration: const BoxDecoration(
                            //   shape: BoxShape.circle,
                            //   color: Colors.orange,
                            // ),
                            // child: const Center(
                            //   child: Icon(
                            //     Icons.home,
                            //     color: Colors.white,
                            //     size: 30,
                            //   ),
                            // ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Vui lòng chọn loại nhà phù hợp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildBadge(), // Thêm badge vào đây
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Positioned buildBadge() {
    return Positioned(
      top: -120,
      left: 0,
      right: 0,
      bottom: 55,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'MoveMate',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
