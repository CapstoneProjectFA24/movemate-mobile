import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

@RoutePage()
class ConfirmServiceBookingScreen extends HookConsumerWidget {
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
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background/bg_1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 350,
                height: MediaQuery.of(context).size.height * (3 / 5),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo/MoveMateLogo2.png',
                          width: 180,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    const Text(
                      'MoveMate đang xử lý!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF57C00),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Image.asset(
                      'assets/images/background/giphy.webp',
                      width: 200,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Mời bạn xác nhận lại dịch vụ của\nbạn để đảm bảo không có sai sót.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF57C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      onPressed: () async {
                        print("Đi đến My Booking");

                        final bookingController =
                            ref.read(bookingControllerProvider.notifier);
                        final orderEntity = await bookingController
                            .getOrderEntityById(order.id);

                        context.router.replaceAll(
                          [
                            OrderDetailsScreenRoute(order: orderEntity ?? order)
                          ],
                        );
                      },
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
