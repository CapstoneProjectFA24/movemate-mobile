import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/home/presentation/widgets/background_image.dart';
import 'package:movemate/features/home/presentation/widgets/header.dart';
import 'package:movemate/features/home/presentation/widgets/promotion_banner.dart';
import 'package:movemate/features/home/presentation/widgets/promotion_section.dart';
import 'package:movemate/features/home/presentation/widgets/service_section.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector.dart';
import 'package:movemate/features/home/presentation/widgets/vehicle_carousel.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BackgroundImage(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ServiceSelector(),
                        SizedBox(height: 16),
                        ServiceSection(),
                      ],
                    ),
                  ),
                ),
                VehicleCarousel(),
                SizedBox(height: 32),
                PromotionBanner(),
                SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PromotionSection(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
