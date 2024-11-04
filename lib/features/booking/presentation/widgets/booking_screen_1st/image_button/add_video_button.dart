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
    return SizedBox(
      width: 100, // Chiều rộng cố định
      height: 20, // Chiều cao cố định
      child: GestureDetector(
        onTap: () {
          // Hiển thị modal khi nhấp vào nút thêm video
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white, // Thiết lập nền trắng cho modal
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nút "Chọn video"
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng modal
                      _chooseVideo(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_library,
                            color: AssetsConstants.primaryDark),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Chọn video',
                            style:
                                TextStyle(color: AssetsConstants.blackColor)),
                      ],
                    ),
                  ),
                ),
                // Nút "Quay video"
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng modal
                      _recordVideo(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam,
                            color: AssetsConstants.primaryDark),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Quay video',
                            style:
                                TextStyle(color: AssetsConstants.blackColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          width: 100, // Đảm bảo kích thước khớp với SizedBox
          height: 50, // Đảm bảo kích thước khớp với SizedBox
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
      ),
    );
  }

  // Hàm chọn video từ thư viện
  void _chooseVideo(BuildContext context) async {
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
  }

  // Hàm quay video bằng camera
  void _recordVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.camera);
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
  }
}
