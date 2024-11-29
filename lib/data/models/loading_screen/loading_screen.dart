import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Đảm bảo import này
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

@RoutePage()
class LoadingScreen extends HookConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingController = ref.read(bookingControllerProvider.notifier);
    final bookingResponse = ref.watch(bookingResponseProvider);
    final bookingControllerState = ref.watch(bookingControllerProvider);

    final isLoading = useState(true);
    final isMounted = useIsMounted();

    useEffect(() {
      Future<void> performCheck() async {
        final bookingId = bookingController.bookingId;

        if (bookingId != null && isMounted()) {
          // Hiển thị LoadingOverlay trong 3 giây
          await Future.delayed(const Duration(seconds: 3));
          if (!isMounted()) return;

          // Tắt LoadingOverlay
          isLoading.value = false;

          // Làm mới dữ liệu đơn đặt hàng
          await bookingController.refreshBookingData(id: bookingId);

          // Lấy phản hồi đơn đặt hàng cập nhật
          final currentBookingResponse = ref.read(bookingResponseProvider);

          // Kiểm tra trạng thái
          if (currentBookingResponse?.status == 'DEPOSITED') {
            // Điều hướng đến màn hình Thanh toán với bookingId
            context.router.replace(PaymentScreenRoute(id: bookingId));
          } else {
            // Giữ nguyên màn hình LoadingScreen mà không làm gì thêm
            // Bạn có thể thêm thông báo hoặc nút thử lại tại đây nếu muốn
          }
        } else {
          print('Booking ID is null in BookingController');
        }
      }

      performCheck();

      return () {
        // Dọn dẹp nếu cần thiết
      };
    }, []);

    return LoadingOverlay(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đang xem xét đơn đặt hàng'),
          centerTitle: true,
          backgroundColor: Colors.orange[700],
          // Bạn có thể bỏ phần actions nếu không cần
          actions: [
            IconButton(
              icon: const Icon(
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
      ),
    );
  }
}
