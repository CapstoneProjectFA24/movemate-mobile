import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';

class ReviewerStatusBottomSheet extends HookConsumerWidget {
  final OrderEntity job;

  const ReviewerStatusBottomSheet({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title;
    String imageUrl1;
    String imageUrl2;

    // TOTO - TUẤN HÃY SET CÁI STATUS ĐỂ HIỂN THỊ HÌNH ẢNH (1 cái ở dưới cho hiển thị hình hen) dùng status của realtime từ booking
    // FLOW WIDGET NÀY CỦA REVIEWER
    // CHỈNH ĐỂ HIỂN THỊ ĐỦ 1 HÌNH ẢNH hiện thực là reivewer dang tới
    // dùng  -------------- bookingStatus.isReviewerMoving ----------------------- là xog
    final bookingAsync = ref.watch(bookingStreamProvider(job.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, job.isReviewOnline);

    switch (job.status) {
      default:
        title = 'Đang di chuyển';
        imageUrl1 = 'https://cdn-icons-png.flaticon.com/512/10053/10053703.png';
        imageUrl2 =
            'https://storage.googleapis.com/a1aa/image/vofMEZ1jlD0TSipQlRFA4flClWaV6oSEOMoua9CHKoeqqXhnA.jpg';
        break;
    }

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 24,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl1,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 20),
                  const ArrowWidget(),
                  const SizedBox(width: 20),
                  Image.network(
                    imageUrl2,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ArrowWidget extends HookConsumerWidget {
  const ArrowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              width: 20,
              height: 2,
              color: Colors.orange,
              margin: const EdgeInsets.symmetric(vertical: 2),
            ),
          ),
        ),
        ClipPath(
          clipper: ArrowClipper(),
          child: Container(
            width: 10,
            height: 10,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width - 10, size.height / 2);
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width - 10, size.height / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
