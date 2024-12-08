// room_media_section.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/media_selection_modal.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_image.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_video.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import 'add_media_button.dart';

class RoomMediaSection extends ConsumerWidget {
  // Changed to ConsumerWidget
  final String roomTitle;
  final RoomType roomType;

  const RoomMediaSection({
    super.key,
    required this.roomTitle,
    required this.roomType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final List<ImageData> images = bookingNotifier.getImages(roomType);
    final List<VideoData> videos = bookingNotifier.getVideos(roomType);

    final bool canAddMoreImages = bookingNotifier.canAddImage(roomType);
    final bool canAddMoreVideos = bookingNotifier.canAddVideo(roomType);

    // Retrieve the loading states
    final bool isUploadingLivingRoomImage =
        bookingState.isUploadingLivingRoomImage;
    final bool isUploadingLivingRoomVideo =
        bookingState.isUploadingLivingRoomVideo;

    // print('check tải ảnh $isUploadingLivingRoomImage');
    // Tổng số item: số hình ảnh + số video + (1 nếu có thể thêm media)
    final int totalItemCount = images.length +
        videos.length +
        ((canAddMoreImages || canAddMoreVideos) ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          content: roomTitle,
          size: AssetsConstants.buttonFontSize + 1,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8), // Space between title and media
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            mainAxisSpacing: 8, // Vertical spacing between rows
            crossAxisSpacing: 16, // Horizontal spacing between columns
            childAspectRatio: 2, // Width to height ratio of each cell
          ),
          itemCount: totalItemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index < images.length) {
              final image = images[index];
              return RoomImage(
                imageData: image,
                roomType: roomType,
              );
            } else if (index < images.length + videos.length) {
              final video = videos[index - images.length];
              return RoomVideo(
                videoData: video,
                roomType: roomType,
              );
            } else {
              // Đây là vị trí cuối cùng, hiển thị AddMediaButton
              return AddMediaButton(
                roomType: roomType,
                hasMedia: images.isNotEmpty || videos.isNotEmpty,
              );
            }
            // return const SizedBox.shrink();
          },
        ),
        // Display a message if the limits are reached
        if (images.length >= BookingNotifier.maxImages ||
            videos.length >= BookingNotifier.maxVideos)
          const Padding(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              // 'Bạn đã đạt giới hạn tối đa là ${BookingNotifier.maxImages} hình ảnh và ${BookingNotifier.maxVideos} video.',
              '',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

Future<void> _showMediaSelectionModal(
    BuildContext context, BookingNotifier bookingNotifier, roomType) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) => MediaSelectionModal(
      roomType: roomType,
      onImageSelected: (imageData) {
        bookingNotifier.addImageToRoom(roomType, imageData);
      },
      onVideoSelected: (videoData) {
        bookingNotifier.addVideoToRoom(roomType, videoData);
      },
    ),
  );
}
