import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

@RoutePage()
class ConfirmServiceBookingScreen extends ConsumerWidget {
  final OrderEntity order;
  const ConfirmServiceBookingScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderControllerProvider);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                "assets/images/Group39449.png",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: 350,
                height: MediaQuery.of(context).size.height *
                    (3 / 5), // 3/5 of screen height
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF57C00), // #f57c00
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Replace the icon with the logo and truck image
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/logo/MoveMateLogo2.png', // Truck image
                        width: 280, // Adjust size as needed
                      ),

                      const SizedBox(height: 60),
                      // Text message
                      const Text(
                        'MoveMate đang xử lý!\nMời bạn xác nhận lại dịch vụ của\nbạn để đảm bảo không có sai sót.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(), // Pushes the button to the bottom
                      // Button to navigate back to home page
                      SizedBox(
                        width: 350 * (6 / 7), // 2/3 of the container width
                        height: 50, // 2/3 of the container width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Background color of the button
                            foregroundColor: const Color(
                                0xFFF57C00), // Text color of the button
                          ),
                          onPressed: () {
                            print("đi đến My booking");

                            context.router.replaceAll(
                                [OrderDetailsScreenRoute(order: order)]);
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
