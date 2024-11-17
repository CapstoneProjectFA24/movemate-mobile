import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';

class TrackingMapBottomSheet extends HookConsumerWidget {
  final OrderEntity job;

  const TrackingMapBottomSheet({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title;
    String imageUrl1;
    String imageUrl2;

    final bookingAsync = ref.watch(bookingStreamProvider(job.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, job.isReviewOnline);

    // switch (job.status) {
    //   case 'đang vận chuyển':
    //     title = 'Đang vận chuyển';
    //     imageUrl1 = 'https://example.com/transit_image1.jpg';
    //     imageUrl2 = 'https://example.com/transit_image2.jpg';
    //     break;
    //   case 'đã giao tới':
    //     title = 'Đã giao tới';
    //     imageUrl1 = 'https://example.com/delivered_image1.jpg';
    //     imageUrl2 = 'https://example.com/delivered_image2.jpg';
    //     break;
    //   case 'đang bốc vác':
    //   default:
    //     title = 'Đang bốc vác';
    //     imageUrl1 =
    //         'https://storage.googleapis.com/a1aa/image/eq28WdUZ0GwXSyUbvWvmQNR1PnwoYdyBBZoxnanwyUGr6V4JA.jpg';
    //     imageUrl2 =
    //         'https://storage.googleapis.com/a1aa/image/vofMEZ1jlD0TSipQlRFA4flClWaV6oSEOMoua9CHKoeqqXhnA.jpg';
    //     break;
    // }

    if (bookingStatus.isDriverInProgressToBuildRoute) {
      title = 'Đang di chuyển đến bạn';
      imageUrl1 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731879919/Delivery-Animation_eecea5.gif';
      imageUrl2 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731880138/house-fif-1_gif_800_600_uiug9w.gif';
    } else if (bookingStatus.isDriverProcessingMoving &&
        !bookingStatus.isStaffDriverComingToBuildRoute) {
      title = 'Đang thực hiện vận chuyển';
      imageUrl1 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731880923/download_yx9ebi.gif';
      imageUrl2 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731880138/house-fif-1_gif_800_600_uiug9w.gif';
    } else if (bookingStatus.isCompleted) {
      title = 'Hoàn tất';
      imageUrl1 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731881178/Truck_Delivery_upapf6.gif';
      imageUrl2 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731881454/download_zamufh.jpg';
    } else {
      title = 'Đang trên đường đến';
      imageUrl1 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731879919/Delivery-Animation_eecea5.gif';
      imageUrl2 =
          'https://res.cloudinary.com/dietfw7lr/image/upload/v1731880138/house-fif-1_gif_800_600_uiug9w.gif';
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
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      imageUrl1,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const ArrowWidget(),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      imageUrl2,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
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
