import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class BookingDetails extends HookConsumerWidget {
  final String? houseType;
  final int numberOfRooms;
  final int numberOfFloors;

  BookingDetails({
    super.key,
    this.houseType,
    this.numberOfRooms = 1,
    this.numberOfFloors = 1,
  });

  // Room images
  final List<String> livingRoomImages = [];
  final List<String> bedroomImages = [
    'assets/images/booking/bedroom/bedroom1.png',
    'assets/images/booking/bedroom/bedroom2.png',
    'assets/images/booking/bedroom/bedroom3.png'
  ];
  final List<String> diningRoomImages = [];
  final List<String> officeRoomImages = [];
  final List<String> bathroomImages = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bookingState = ref.watch(bookingProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomImageSection('Phòng khách', livingRoomImages),
          // const SizedBox(height: 16),
          _buildRoomImageSection('Phòng ngủ', bedroomImages),
          // const SizedBox(height: 16),
          _buildRoomImageSection('Phòng ăn/ bếp', diningRoomImages),
          // const SizedBox(height: 16),
          _buildRoomImageSection('Phòng làm việc', officeRoomImages),
          // const SizedBox(height: 16),
          _buildRoomImageSection('Phòng vệ sinh', bathroomImages),
        ],
      ),
    );
  }

  // Helper method to display room images
  Widget _buildRoomImageSection(String roomTitle, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        // const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1, // +1 for "Thêm ảnh" button
              itemBuilder: (context, index) {
                return (index == images.length)
                    ? _buildAddImageButton() // "Thêm ảnh" button
                    : _buildRoomImage(images[index]); // Room image
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget for room image
  Widget _buildRoomImage(String imagePath) {
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
          ],
        ),
      ),
    );
  }

  // Widget for "Thêm ảnh" (Add Image) button
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // Handle add image
      },
      child: Center(
        child: Container(
          width: 295,
          height: 44,
          margin: const EdgeInsets.only(right: 8),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: AssetsConstants.greyColor,
          // style: BorderStyle.solid, // Viền đứt đoạn
          //   ),
          //   borderRadius: BorderRadius.circular(12),
          // ),
          child: DottedBorder(
            color: AssetsConstants.greyColor, // Màu viền đứt đoạn
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [8, 4], // Đặt pattern cho viền đứt đoạn

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
