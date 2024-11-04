// room_media_section.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';

import 'room_image.dart';
import 'room_video.dart';
import 'add_image_button.dart';
import 'add_video_button.dart';

class RoomMediaSection extends StatelessWidget {
  final String roomTitle;
  final RoomType roomType;
  final BookingNotifier bookingNotifier;

  const RoomMediaSection({
    super.key,
    required this.roomTitle,
    required this.roomType,
    required this.bookingNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final List<ImageData> images = bookingNotifier.getImages(roomType);
    final List<VideoData> videos = bookingNotifier.getVideos(roomType);

    final bool canAddMoreImages = bookingNotifier.canAddImage(roomType);
    final bool canAddMoreVideos = bookingNotifier.canAddVideo(roomType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8), // Khoảng cách giữa tiêu đề và hình ảnh/video
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Số cột
            mainAxisSpacing: 8, // Khoảng cách dọc giữa các hàng
            crossAxisSpacing: 8, // Khoảng cách ngang giữa các cột
            childAspectRatio: 1, // Tỉ lệ chiều rộng và chiều cao của mỗi ô
          ),
          itemCount: images.length +
              videos.length +
              (canAddMoreImages ? 1 : 0) +
              (canAddMoreVideos
                  ? 1
                  : 0), // Thêm nút thêm hình ảnh và video nếu có thể
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int imageCount = images.length;
            int videoCount = videos.length;

            // Hiển thị hình ảnh
            if (index < imageCount) {
              final image = images[index];
              return RoomImage(
                imageData: image,
                roomType: roomType,
                bookingNotifier: bookingNotifier,
              );
            }

            // Hiển thị video
            if (index < imageCount + videoCount) {
              final video = videos[index - imageCount];
              return RoomVideo(
                videoData: video,
                roomType: roomType,
                bookingNotifier: bookingNotifier,
              );
            }

            // Hiển thị nút thêm hình ảnh
            if (canAddMoreImages && index == imageCount + videoCount) {
              return AddImageButton(
                roomType: roomType,
                bookingNotifier: bookingNotifier,
                hasImages: images.isNotEmpty,
              );
            }

            // Hiển thị nút thêm video
            if (canAddMoreVideos &&
                index == imageCount + videoCount + (canAddMoreImages ? 1 : 0)) {
              return AddVideoButton(
                roomType: roomType,
                bookingNotifier: bookingNotifier,
                hasVideos: videos.isNotEmpty,
              );
            }

            return const SizedBox.shrink(); // Không hiển thị gì
          },
        ),
        // Hiển thị thông báo nếu đã đạt giới hạn
        if (images.length >= BookingNotifier.maxImages ||
            videos.length >= BookingNotifier.maxVideos)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Bạn đã đạt giới hạn tối đa là ${BookingNotifier.maxImages} hình ảnh và ${BookingNotifier.maxVideos} video.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
