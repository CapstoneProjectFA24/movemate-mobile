import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_image_section.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_media_section.dart';

// Import the ImageData class

class BookingDetails extends HookConsumerWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoomMediaSection(
            roomTitle: 'Tải ảnh lên',
            roomType: RoomType.livingRoom,
            // bookingNotifier: bookingNotifier,
          ),
          // RoomImageSection(
          //   roomTitle: 'Phòng ngủ',
          //   images: bookingState.bedroomImages,
          //   roomType: RoomType.bedroom,
          //   bookingNotifier: bookingNotifier,
          // ),
          // RoomImageSection(
          //   roomTitle: 'Phòng ăn/ bếp',
          //   images: bookingState.diningRoomImages,
          //   roomType: RoomType.diningRoom,
          //   bookingNotifier: bookingNotifier,
          // ),
          // RoomImageSection(
          //   roomTitle: 'Phòng làm việc',
          //   images: bookingState.officeRoomImages,
          //   roomType: RoomType.officeRoom,
          //   bookingNotifier: bookingNotifier,
          // ),
          // RoomImageSection(
          //   roomTitle: 'Phòng vệ sinh',
          //   images: bookingState.bathroomImages,
          //   roomType: RoomType.bathroom,
          //   bookingNotifier: bookingNotifier,
          // ),
        ],
      ),
    );
  }
}
