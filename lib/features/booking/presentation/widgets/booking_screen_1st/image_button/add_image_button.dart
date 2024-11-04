// add_image_button.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

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
        // Kiểm tra số lượng hình ảnh hiện tại
        if (!bookingNotifier.canAddImage(roomType)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Bạn chỉ có thể thêm tối đa ${BookingNotifier.maxImages} hình ảnh.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          // Upload hình ảnh lên Cloudinary
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
            // Tạo đối tượng ImageData
            final imageData = ImageData(
              url: response.secureUrl,
              publicId: response.publicId,
            );
            // Thêm hình ảnh vào trạng thái booking
            bookingNotifier.addImageToRoom(roomType, imageData);
          } catch (e) {
            // Xử lý lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload image')),
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
            child: hasImages
                ? const Icon(Icons.add, color: AssetsConstants.greyColor)
                : const Text('Thêm ảnh',
                    style: TextStyle(color: AssetsConstants.greyColor)),
          ),
        ),
      ),
    );
  }
}
