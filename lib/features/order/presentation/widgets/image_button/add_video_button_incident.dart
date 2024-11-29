// add_video_button.dart
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddVideoButton extends ConsumerWidget {
  // Changed to ConsumerWidget
  final RoomType roomType;
  final bool hasVideos;

  const AddVideoButton({
    super.key,
    required this.roomType,
    required this.hasVideos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final isUploadingLivingRoomVideo =
        ref.watch(bookingProvider).isUploadingLivingRoomVideo;

    return SizedBox(
      width: 100, // Fixed width
      height: 50, // Fixed height
      child: isUploadingLivingRoomVideo && roomType == RoomType.livingRoom
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : GestureDetector(
              onTap: () {
                // Show modal when tapping the add video button
                showModalBottomSheet(
                  context: context,
                  backgroundColor:
                      Colors.white, // Set white background for modal
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Choose Video" button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close modal
                            _chooseVideo(context, bookingNotifier);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_library,
                                  color: AssetsConstants.primaryDark),
                              SizedBox(width: 5),
                              Text('Chọn video',
                                  style: TextStyle(
                                      color: AssetsConstants.blackColor)),
                            ],
                          ),
                        ),
                      ),
                      // "Record Video" button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close modal
                            _recordVideo(context, bookingNotifier);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam,
                                  color: AssetsConstants.primaryDark),
                              SizedBox(width: 5),
                              Text('Quay video',
                                  style: TextStyle(
                                      color: AssetsConstants.blackColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 100, // Ensure size matches SizedBox
                height: 50, // Ensure size matches SizedBox
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
                        ? const Icon(Icons.videocam,
                            color: AssetsConstants.greyColor)
                        : const Text('Thêm video',
                            style: TextStyle(color: AssetsConstants.greyColor)),
                  ),
                ),
              ),
            ),
    );
  }

  // Function to choose video from gallery
  Future<void> _chooseVideo(
      BuildContext context, BookingNotifier bookingNotifier) async {
    if (roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomVideo(true);
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Check video size
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
// dve1zpp4s
        // Upload video to Cloudinary
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
          // Create VideoData object
          final videoData = VideoData(
            url: response.secureUrl,
            publicId: response.publicId,
            size: fileSize,
          );
          // Add video to booking state
          // await bookingNotifier.addVideoToRoom(roomType, videoData);
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload video')),
          );
        }
      }
    } finally {
      if (roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomVideo(false);
      }
    }
  }

  // Function to record video using camera
  Future<void> _recordVideo(
      BuildContext context, BookingNotifier bookingNotifier) async {
    if (roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomVideo(true);
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        // Check video size
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

        // Upload video to Cloudinary
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
          // Create VideoData object
          final videoData = VideoData(
            url: response.secureUrl,
            publicId: response.publicId,
            size: fileSize,
          );
          // Add video to booking state
          // await bookingNotifier.addVideoToRoom(roomType, videoData);
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload video')),
          );
        }
      }
    } finally {
      if (roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomVideo(false);
      }
    }
  }
}
