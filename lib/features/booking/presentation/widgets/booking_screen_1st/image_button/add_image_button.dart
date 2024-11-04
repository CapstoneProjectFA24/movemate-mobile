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
    return SizedBox(
      width: 100, // Chiều rộng cố định
      height: 50, // Chiều cao cố định
      child: GestureDetector(
        onTap: () {
          // Hiển thị modal khi nhấp vào nút thêm hình ảnh
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white, // Thiết lập nền trắng cho modal
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nút "Chọn ảnh"
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng modal
                      _chooseImage(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: AssetsConstants.primaryDark),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Chọn ảnh',
                            style:
                                TextStyle(color: AssetsConstants.blackColor)),
                      ],
                    ),
                  ),
                ),
                // Nút "Chụp hình"
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng modal
                      _takePhoto(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt,
                            color: AssetsConstants.primaryDark),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Chụp hình',
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

  // Hàm chọn ảnh từ thư viện
  void _chooseImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload ảnh lên Cloudinary
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
        // Thêm ảnh vào trạng thái booking
        bookingNotifier.addImageToRoom(roomType, imageData);
      } catch (e) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  // Hàm chụp ảnh bằng camera
  void _takePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // Upload ảnh lên Cloudinary
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
        // Thêm ảnh vào trạng thái booking
        bookingNotifier.addImageToRoom(roomType, imageData);
      } catch (e) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }
}
