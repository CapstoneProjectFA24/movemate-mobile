// room_image.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class RoomImage extends StatelessWidget {
  final ImageData imageData;
  final RoomType roomType;
  final BookingNotifier bookingNotifier;

  const RoomImage({
    super.key,
    required this.imageData,
    required this.roomType,
    required this.bookingNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50, // Chiều rộng cố định
      height: 50, // Chiều cao cố định
      child: Container(
        width: 50, // Đảm bảo kích thước khớp với SizedBox
        height: 50, // Đảm bảo kích thước khớp với SizedBox
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageData.url),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  bookingNotifier.removeImageFromRoom(roomType, imageData);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AssetsConstants.pinkColor,
                  ),
                  child: const Icon(Icons.delete,
                      color: AssetsConstants.whiteColor, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
