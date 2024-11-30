import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/order_provider.dart';

class RoomImageIncident extends ConsumerWidget {
  // Changed to ConsumerWidget
  final ImageData imageData;
  final RoomType roomType;

  const RoomImageIncident({
    super.key,
    required this.imageData,
    required this.roomType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return SizedBox(
      width: 50, // Fixed width
      height: 50, // Fixed height
      child: Container(
        width: 50,
        height: 50,
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
