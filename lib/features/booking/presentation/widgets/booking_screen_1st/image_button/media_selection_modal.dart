// media_selection_modal.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'add_media_button.dart';

class MediaSelectionModal extends StatelessWidget {
  final RoomType roomType;
  final Function(ImageData) onImageSelected;
  final Function(VideoData) onVideoSelected;

  const MediaSelectionModal({
    super.key,
    required this.roomType,
    required this.onImageSelected,
    required this.onVideoSelected,
  });

  Future<List<ImageData>> getImagesFromLibrary() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    final List<ImageData> imageDataList = [];

    for (var pickedFile in pickedFiles) {
      final imageData = ImageData(
        url: pickedFile.path,
        publicId: '', // Bạn có thể bỏ qua trường này nếu không cần thiết
      );
      imageDataList.add(imageData);
    }

    return imageDataList;

    return [];
  }

  Future<List<VideoData>> getVideosFromLibrary(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final int fileSize = await pickedFile.length();
      if (fileSize > BookingNotifier.maxVideoSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dung lượng video không được vượt quá 25 MB.'),
            backgroundColor: Colors.red,
          ),
        );
        return [];
      }

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
        final videoData = VideoData(
          url: response.secureUrl,
          publicId: response.publicId,
          size: fileSize,
        );
        return [videoData];
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload video')),
        );
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hiển thị danh sách hình ảnh và video từ thư viện
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              // Lấy dữ liệu hình ảnh hoặc video tại vị trí index
              final media = getMediaAtIndex(index, context);

              // Hiển thị hình ảnh hoặc video tương ứng
              if (media is ImageData) {
                return GestureDetector(
                  onTap: () => onImageSelected(media),
                  child: Image.network(media.url),
                );
              } else if (media is VideoData) {
                return GestureDetector(
                  onTap: () => onVideoSelected(media),
                  child:
                      Image.network(media.url), // Hiển thị thumbnail của video
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),

        // Nút đóng modal
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  // Hàm lấy dữ liệu media tại vị trí index
  dynamic getMediaAtIndex(int index, BuildContext context) {
    // Lấy danh sách hình ảnh và video từ thư viện
    final images = getImagesFromLibrary();
    final videos = getVideosFromLibrary(context);

    // Trả về hình ảnh hoặc video tương ứng
    // if (index < images.length) {
    //   return images[index];
    // } else if (index < images.length + videos.length) {
    //   return videos[index - images.length];
    // }

    return null;
  }
}
