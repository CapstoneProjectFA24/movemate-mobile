// booking_details.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:image_picker/image_picker.dart';

class BookingDetails extends HookConsumerWidget {
  // const BookingDetails({super.key});
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomImageSection(
            context,
            'Phòng khách',
            bookingState.livingRoomImages,
            RoomType.livingRoom,
            bookingNotifier,
          ),
          _buildRoomImageSection(
            context,
            'Phòng ngủ',
            bookingState.bedroomImages,
            RoomType.bedroom,
            bookingNotifier,
          ),
          _buildRoomImageSection(
            context,
            'Phòng ăn/ bếp',
            bookingState.diningRoomImages,
            RoomType.diningRoom,
            bookingNotifier,
          ),
          _buildRoomImageSection(
            context,
            'Phòng làm việc',
            bookingState.officeRoomImages,
            RoomType.officeRoom,
            bookingNotifier,
          ),
          _buildRoomImageSection(
            context,
            'Phòng vệ sinh',
            bookingState.bathroomImages,
            RoomType.bathroom,
            bookingNotifier,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomImageSection(
    BuildContext context,
    String roomTitle,
    List<String> images,
    RoomType roomType,
    BookingNotifier bookingNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1, // +1 for "Thêm ảnh" button
              itemBuilder: (context, index) {
                return (index == images.length)
                    ? _buildAddImageButton(context, roomType, bookingNotifier)
                    : _buildRoomImage(images[index], roomType, bookingNotifier);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomImage(
      String imagePath, RoomType roomType, BookingNotifier bookingNotifier) {
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

  Widget _buildAddImageButton(BuildContext context, RoomType roomType,
      BookingNotifier bookingNotifier) {
    return GestureDetector(
      onTap: () async {
        // Handle add image using Image Picker or any other method
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          bookingNotifier.addImageToRoom(roomType, image.path);
        }
      },
      child: Center(
        child: Container(
          width: 295,
          height: 44,
          margin: const EdgeInsets.only(right: 8),
          child: DottedBorder(
            color: AssetsConstants.greyColor,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [8, 4],
            child: const Center(
              child: Text('Thêm ảnh',
                  style: TextStyle(color: AssetsConstants.greyColor)),
            ),
          ),
        ),
      ),
    );
  }
}
