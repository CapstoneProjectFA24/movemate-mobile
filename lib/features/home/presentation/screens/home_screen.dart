import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/home/presentation/widgets/background_image.dart';
import 'package:movemate/features/home/presentation/widgets/header.dart'
    as home_header;
import 'package:movemate/features/home/presentation/widgets/promotion/voucher_section.dart';
import 'package:movemate/features/home/presentation/widgets/promotion_section.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/service_selector.dart';
import 'package:movemate/features/home/presentation/widgets/vehicle_carousel.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const BackgroundImage(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const home_header.Header(),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ServiceSelector(),
                        SizedBox(height: 16),
                        // Add other widgets if needed
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: FadeInRight(
                    child: const Padding(
                      padding: EdgeInsets.all(0.0),
                      child: DiscountCodesWidget(),
                    ),
                  ),
                ),
                FadeInDown(child: const VehicleCarousel()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
