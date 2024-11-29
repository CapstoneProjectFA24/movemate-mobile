// add_image_button.dart
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddImageButton extends ConsumerWidget {
  // Changed to ConsumerWidget
  final RoomType roomType;
  final bool hasImages;

  const AddImageButton({
    super.key,
    required this.roomType,
    required this.hasImages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final isUploadingLivingRoomImage =
        ref.watch(bookingProvider).isUploadingLivingRoomImage;

    return SizedBox(
      width: 100, // Fixed width
      height: 50, // Fixed height
      child: isUploadingLivingRoomImage && roomType == RoomType.livingRoom
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : GestureDetector(
              onTap: () {
                // Show modal when tapping the add image button
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
                      // "Choose Image" button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close modal
                            _chooseImage(context, bookingNotifier);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                  color: AssetsConstants.primaryDark),
                              SizedBox(width: 5),
                              Text('Chọn ảnh',
                                  style: TextStyle(
                                      color: AssetsConstants.blackColor)),
                            ],
                          ),
                        ),
                      ),
                      // "Take Photo" button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close modal
                            _takePhoto(context, bookingNotifier);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  color: AssetsConstants.primaryDark),
                              SizedBox(width: 5),
                              Text('Chụp hình',
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
                    child: hasImages
                        ? const Icon(Icons.add,
                            color: AssetsConstants.greyColor)
                        : const Text('Thêm ảnh',
                            style: TextStyle(color: AssetsConstants.greyColor)),
                  ),
                ),
              ),
            ),
    );
  }

  // Function to choose image from gallery
  Future<void> _chooseImage(
      BuildContext context, BookingNotifier bookingNotifier) async {
    if (roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomImage(true);
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Upload image to Cloudinary
        final cloudinary =
            CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false);
        try {
          final CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              pickedFile.path,
              folder: 'movemate/images',
              resourceType: CloudinaryResourceType.Image,
            ),
          );
          // Create ImageData object
          final imageData = ImageData(
            url: response.secureUrl,
            publicId: response.publicId,
          );
          // Add image to booking state
          await bookingNotifier.addImageToRoom(roomType, imageData);
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    } finally {
      if (roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomImage(false);
      }
    }
  }

  // Function to take photo using camera
  Future<void> _takePhoto(
      BuildContext context, BookingNotifier bookingNotifier) async {
    if (roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomImage(true);
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // Upload image to Cloudinary
        final cloudinary =
            CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false);
        try {
          final CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              pickedFile.path,
              folder: 'movemate/images',
              resourceType: CloudinaryResourceType.Image,
            ),
          );
          // Create ImageData object
          final imageData = ImageData(
            url: response.secureUrl,
            publicId: response.publicId,
          );
          // Add image to booking state
          await bookingNotifier.addImageToRoom(roomType, imageData);
        } catch (e) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    } finally {
      if (roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomImage(false);
      }
    }
  }
}
