// add_video_button.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import 'video_data.dart';

class AddVideoButton extends StatelessWidget {
  final RoomType roomType;
  final BookingNotifier bookingNotifier;
  final bool hasVideos;

  const AddVideoButton({
    super.key,
    required this.roomType,
    required this.bookingNotifier,
    required this.hasVideos,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Kiểm tra số lượng video hiện tại
        if (!bookingNotifier.canAddVideo(roomType)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Bạn chỉ có thể thêm tối đa ${BookingNotifier.maxVideos} video.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile =
            await picker.pickVideo(source: ImageSource.gallery);
        if (pickedFile != null) {
          // Kiểm tra dung lượng video
          final int fileSize = await pickedFile.length();
          if (fileSize > BookingNotifier.maxVideoSize) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dung lượng video không được vượt quá 25 MB.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Upload video lên Cloudinary
          final cloudinary =
              CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false);
          try {
            final CloudinaryResponse response = await cloudinary.uploadFile(
              CloudinaryFile.fromFile(
                pickedFile.path,
                folder: 'movemate/videos',
                resourceType: CloudinaryResourceType.Video,
              ),
            );
            // Tạo đối tượng VideoData
            final videoData = VideoData(
              url: response.secureUrl,
              publicId: response.publicId,
              size: fileSize,
            );
            // Thêm video vào trạng thái booking
            bookingNotifier.addVideoToRoom(roomType, videoData);
          } catch (e) {
            // Xử lý lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload video')),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: DottedBorder(
          color: AssetsConstants.greyColor,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: const [8, 4],
          child: Center(
            child: hasVideos
                ? const Icon(Icons.videocam, color: AssetsConstants.greyColor)
                : const Text('Thêm video',
                    style: TextStyle(color: AssetsConstants.greyColor)),
          ),
        ),
      ),
    );
  }
}
