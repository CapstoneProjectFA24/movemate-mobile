import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class RoomImage extends StatelessWidget {
  final String imagePath;
  final RoomType roomType;
  final BookingNotifier bookingNotifier;

  const RoomImage({
    super.key,
    required this.imagePath,
    required this.roomType,
    required this.bookingNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 71,
        height: 56,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
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
                  bookingNotifier.removeImageFromRoom(roomType, imagePath);
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
