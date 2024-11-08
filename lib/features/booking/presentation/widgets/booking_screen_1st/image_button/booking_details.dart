import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_media_section.dart';


class BookingDetails extends HookConsumerWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoomMediaSection(
            roomTitle: 'Tải ảnh lên',
            roomType: RoomType.livingRoom,
          ),
        ],
      ),
    );
  }
}
