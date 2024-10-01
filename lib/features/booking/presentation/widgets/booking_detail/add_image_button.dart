import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

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
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          bookingNotifier.addImageToRoom(roomType, image.path);
        }
      },
      child: Center(
        child: Container(
          width: hasImages ? 71 : 295,
          height: hasImages ? 56 : 44,
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
