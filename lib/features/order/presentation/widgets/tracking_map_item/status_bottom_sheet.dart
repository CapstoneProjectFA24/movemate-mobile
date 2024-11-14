import 'package:flutter/material.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

class TrackingMapBottomSheet extends StatelessWidget {
  final OrderEntity job;

  const TrackingMapBottomSheet({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl1;
    String imageUrl2;

    // Define different images and titles for each status
    switch (job.status) {
      case 'đang vận chuyển':
        title = 'Đang vận chuyển';
        imageUrl1 = 'https://example.com/transit_image1.jpg';
        imageUrl2 = 'https://example.com/transit_image2.jpg';
        break;
      case 'đã giao tới':
        title = 'Đã giao tới';
        imageUrl1 = 'https://example.com/delivered_image1.jpg';
        imageUrl2 = 'https://example.com/delivered_image2.jpg';
        break;
      case 'đang bốc vác':
      default:
        title = 'Đang bốc vác';
        imageUrl1 =
            'https://storage.googleapis.com/a1aa/image/eq28WdUZ0GwXSyUbvWvmQNR1PnwoYdyBBZoxnanwyUGr6V4JA.jpg';
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

class ArrowWidget extends StatelessWidget {
  const ArrowWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
