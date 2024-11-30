// room_media_section.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/resource.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import '../../provider/order_provider.dart';
import 'room_image_incident.dart';
import 'room_video_incident.dart';
import 'add_image_button_incident.dart';
import 'add_video_button_incident.dart';

class RoomMediaSectionIncident extends ConsumerWidget {
  // Changed to ConsumerWidget
  final String roomTitle;
  final RoomType roomType;

  const RoomMediaSectionIncident({
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
// Thông báo đến màn hình là có hình ảnh hoặc video vừa cập nhật
    bookingState.isUploadingLivingRoomImage;
    bookingState.isUploadingLivingRoomVideo;

    // print('check tải ảnh $isUploadingLivingRoomImage');

    // Chuyển đổi hình ảnh thành Resource
    List<Resource> resourceList = [];

    void addImagesToResourceList(List<ImageData> images, String resourceCode) {
      resourceList.addAll(images.map((imageData) => Resource(
            type: 'IMG',
            resourceUrl: imageData.url,
            resourceCode: resourceCode,
          )));
    }

    void addVideosToResourceList(List<VideoData> videos, String resourceCode) {
      resourceList.addAll(videos.map((imageData) => Resource(
            type: 'VIDEO',
            resourceUrl: imageData.url,
            resourceCode: resourceCode,
          )));
    }

    addImagesToResourceList(bookingState.livingRoomImages, 'living_room');
    addVideosToResourceList(bookingState.livingRoomVideos, 'living_room');
    print("tuan checking ${resourceList.toString()} ");
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
          itemCount: images.length +
              videos.length +
              (canAddMoreImages ? 1 : 0) +
              (canAddMoreVideos ? 1 : 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int imageCount = images.length;
            int videoCount = videos.length;

            // Display images
            if (index < imageCount) {
              final image = images[index];
              return RoomImageIncident(
                imageData: image,
                roomType: roomType,
              );
            }

            // Display videos
            if (index < imageCount + videoCount) {
              final video = videos[index - imageCount];
              return RoomVideoIncident(
                videoData: video,
                roomType: roomType,
              );
            }

            // Calculate the current position for additional buttons
            int additionalIndex = index - imageCount - videoCount;

            // Display Add Image button or loader
            if (canAddMoreImages && additionalIndex == 0) {
              return AddImageButtonIncident(
                roomType: roomType,
                hasImages: images.isNotEmpty,
              );
            }

            // Display Add Video button or loader
            if (canAddMoreVideos &&
                (additionalIndex == (canAddMoreImages ? 1 : 0))) {
              return AddVideoButtonIncident(
                roomType: roomType,
                hasVideos: videos.isNotEmpty,
              );
            }
            print('check index $imageCount');
            print('check index ${images.length}');
            return const SizedBox.shrink(); // Render nothing
          },
        ),
        // Display a message if the limits are reached
        if (images.length >= OrderNotifier.maxImages ||
            videos.length >= OrderNotifier.maxVideos)
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
