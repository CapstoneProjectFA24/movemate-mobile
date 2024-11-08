import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/home/presentation/screens/voucher/voucher_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_screen/promotion_screen.dart';

class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Khuyến mãi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.local_fire_department,
                    size: 24,
                    color: Colors.orange,
                  ),
                ],
              ),
              // Thay thế Text bằng TextButton để làm cho "Xem tất cả" tương tác
              TextButton(
                onPressed: () {
                  // Chuyển hướng đến VoucherScreenRoute khi nhấn vào "Xem tất cả"
                  // context.router.pushAndPopUntil(
                  //   const TabViewScreenRoute(children: [
                  //     PromotionScreenRoute(),
                  //   ]),
                  //   predicate: (route) => false,
                  // );
                },
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPromotionCard(
                title: 'Cashback up to',
                discount: '80%',
                description: 'On local events',
                buttonText: 'LOOK EVENTS',
                backgroundColor: Colors.teal,
              ),
              const SizedBox(width: 8),
              _buildPromotionCard(
                title: 'Up to',
                discount: '50% Off',
                description: 'On domestic flights',
                buttonText: 'BOOK NOW',
                backgroundColor: Colors.pinkAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String discount,
    required String description,
    required String buttonText,
    required Color backgroundColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Container(
            width: 208, // Ensure consistent width
            height: 128, // Ensure consistent height
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12, // Adjusted font size
                    color: Colors.white,
                  ),
                ),
                Text(
                  discount,
                  style: const TextStyle(
                    fontSize: 20, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10, // Adjusted font size
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 96,
                    height: 30, // Set button height to 85
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero, // Remove padding
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10, // Adjusted font size
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
