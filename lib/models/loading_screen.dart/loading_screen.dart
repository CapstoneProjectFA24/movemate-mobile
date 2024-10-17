import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

@RoutePage()
class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingControllerState = ref.watch(bookingControllerProvider);

    return LoadingOverlay(
        isLoading: bookingControllerState.isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Đang xem xét đơn đặt hàng'),
            centerTitle: true,
            backgroundColor: Colors.orange[700],
            // automaticallyImplyLeading: true,
            actions: [
              IconButton(
                icon: const Icon(
                  // FontAwesomeIcons.refresh,
                  FontAwesomeIcons.house,
                  size: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  context.router.replace(
                    const TabViewScreenRoute(),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Group39449.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 300,
                height: 500,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.truck,
                      size: 40,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MoveMate',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Vui lòng chờ, hệ thống đang xem xét đơn đặt hàng của bạn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Image(
                      image: AssetImage('assets/images/loading_map.png'),
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
