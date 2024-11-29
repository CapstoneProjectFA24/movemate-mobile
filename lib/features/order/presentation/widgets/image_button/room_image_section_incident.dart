import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

// Import ImageData class
import 'package:movemate/features/booking/domain/entities/image_data.dart';

import 'add_image_button_incident.dart';
import 'room_image_incident.dart';

class RoomImageSection extends StatelessWidget {
  final String roomTitle;
  final List<ImageData> images;
  final RoomType roomType;
  final BookingNotifier bookingNotifier;

  static const int maxImages = 5; // Giới hạn số lượng hình ảnh tối đa

  const RoomImageSection({
    super.key,
    required this.roomTitle,
    required this.images,
    required this.roomType,
    required this.bookingNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final bool canAddMore = images.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8), // Khoảng cách giữa tiêu đề và hình ảnh
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Số cột
            mainAxisSpacing: 8, // Khoảng cách dọc giữa các hàng
            crossAxisSpacing: 8, // Khoảng cách ngang giữa các cột
            childAspectRatio: 1, // Tỉ lệ chiều rộng và chiều cao của mỗi ô
          ),
          itemCount: canAddMore
              ? images.length + 1
              : images.length, // Thêm một cho nút thêm hình ảnh nếu có thể
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (canAddMore && index == images.length) {
              return AddImageButton(
                roomType: roomType,
                hasImages: images.isNotEmpty,
              );
            } else {
              return RoomImage(
                imageData: images[index],
                roomType: roomType,
              );
            }
          },
        ),
        if (images.length >= maxImages)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              // 'Bạn đã đạt giới hạn tối đa là $maxImages hình ảnh.',
              '',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
