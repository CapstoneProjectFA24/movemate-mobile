import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';

// This is the provider to manage state (if needed)
final CashPaymentProvider = Provider<bool>((ref) {
  return true; // or some logic to determine registration status
});

@RoutePage()
class CashPaymentWaiting extends HookConsumerWidget {
  final int bookingId;
  const CashPaymentWaiting({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the CashPaymentProvider
    final isSuccess = ref.watch(CashPaymentProvider);
    final bookingAsync = ref.watch(bookingStreamProvider(bookingId.toString()));

    final orderEntity = useFetchObject<OrderEntity>(
        function: (context) async {
          return ref
              .read(bookingControllerProvider.notifier)
              .getOrderEntityById(bookingId);
        },
        context: context);

    final bookingStatus = useBookingStatus(
        bookingAsync.value, orderEntity.data?.isReviewOnline ?? false);

    final checkCashPayment = bookingStatus.isCompleted;

    if (checkCashPayment && orderEntity.data != null) {
      context.router
          .push(LastTransactionResultCashPaymentRoute(order: orderEntity.data));
    }

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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon similar to the Font Awesome 'check'
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: Image.asset(
                        'assets/images/background/giphy.gif',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text message
                  Text(
                    isSuccess ? 'Chờ nhân viên xác nhận ' : 'Thất bại',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Home Icon Button at the top-right corner
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                final tabsRouter = context.router.root
                    .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
                if (tabsRouter != null) {
                  tabsRouter.setActiveIndex(0);
                  context.router.popUntilRouteWithName(TabViewScreenRoute.name);
                } else {
                  context.router.pushAndPopUntil(
                    const TabViewScreenRoute(children: [
                      HomeScreenRoute(),
                    ]),
                    predicate: (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
