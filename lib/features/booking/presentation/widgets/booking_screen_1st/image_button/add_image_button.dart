import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

// Import ImageData class
import 'package:movemate/features/booking/domain/entities/image_data.dart';

class AddImageButton extends StatelessWidget {
  final RoomType roomType;
  final BookingNotifier bookingNotifier;
  final bool hasImages;

  const AddImageButton({
    super.key,
    required this.roomType,
    required this.bookingNotifier,
    required this.hasImages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
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
                folder: 'movemate',
                resourceType: CloudinaryResourceType.Image,
              ),
            );
            // Create ImageData
            final imageData = ImageData(
              url: response.secureUrl,
              publicId: response.publicId,
            );
            // Add image to booking state
            bookingNotifier.addImageToRoom(roomType, imageData);
          } catch (e) {
            // Handle errors
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload image')),
            );
          }
        }
      },
      child: Center(
        child: Container(
          width: hasImages ? 71 : 340,
          height: hasImages ? 56 : 60,
          margin: const EdgeInsets.only(right: 8),
          child: DottedBorder(
            color: AssetsConstants.greyColor,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [8, 4],
            child: Center(
              child: hasImages
                  ? const Icon(Icons.add, color: AssetsConstants.greyColor)
                  : const Text('Thêm ảnh',
                      style: TextStyle(color: AssetsConstants.greyColor)),
            ),
          ),
        ),
      ),
    );
  }
}
