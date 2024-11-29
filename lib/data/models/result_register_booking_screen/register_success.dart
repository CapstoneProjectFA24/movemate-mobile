import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

// This is the provider to manage state (if needed)
final registrationStatusProvider = Provider<bool>((ref) {
  return true; // or some logic to determine registration status
});

@RoutePage()
class RegistrationSuccessScreen extends ConsumerStatefulWidget {
  final OrderEntity order;
  const RegistrationSuccessScreen({super.key, required this.order});

  @override
  RegistrationSuccessScreenState createState() =>
      RegistrationSuccessScreenState();
}

class RegistrationSuccessScreenState
    extends ConsumerState<RegistrationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Bắt đầu đếm thời gian 2 giây trước khi chuyển màn hình
    Timer(const Duration(seconds: 2), () {
      AutoRouter.of(context).push(
        ConfirmServiceBookingScreenRoute(order: widget.order),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = ref.watch(registrationStatusProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/Group39449.png",
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background image
          Center(
            child: Container(
              width: 350,
              height: MediaQuery.of(context).size.height *
                  (3 / 5), // 2/3 of screen height
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF57C00),
                // .withOpacity(0.8), // Add some transparency
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon similar to the Font Awesome 'check'
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFFF57C00), // Match background color
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text message
                  Text(
                    isSuccess ? 'Đăng ký thành công' : 'Thất bại',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
