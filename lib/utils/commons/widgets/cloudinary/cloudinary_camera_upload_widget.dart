// File: cloudinary_camera_upload_widget.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/resource.dart';


class CloudinaryCameraUploadWidget extends HookConsumerWidget {
  final bool disabled;
  final Function(String url, String publicId) onImageUploaded;
  final Function(String publicId) onImageRemoved;
  final List<String> imagePublicIds;
  final Function(String) onImageTapped;
  final Widget? optionalButton;
  final bool showCameraButton;
  final Function(Resource)? onUploadComplete;

  const CloudinaryCameraUploadWidget({
    super.key,
    this.disabled = false,
    required this.onImageUploaded,
    required this.onImageRemoved,
    required this.imagePublicIds,
    required this.onImageTapped,
    this.optionalButton,
    this.showCameraButton = true,
    this.onUploadComplete,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = useMemoized(() => ImagePicker());
    final isLoading = useState(false);
    final cloudinary = useMemoized(
        () => CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false));
    Future<void> uploadImageFromCamera() async {
      if (disabled || isLoading.value) return;

      try {
        isLoading.value = true;

        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (pickedFile == null) return;

        final File imageFile = File(pickedFile.path);

        final CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            imageFile.path,
            folder: 'movemate',
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        print('check 1 2 Upload success: ${response.secureUrl}');

        onImageUploaded(
          response.secureUrl,
          response.publicId,
        );
 
      } catch (e) {
        if (e is DioException) {
          print('Failed to upload image: ${e.response?.data}');
          print('Status Code: ${e.response?.statusCode}');
          print('Headers: ${e.response?.headers}');
        } else {
          print('Other error: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePublicIds.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagePublicIds.length,
              itemBuilder: (context, index) {
                final imageUrl =
                    'https://res.cloudinary.com/dkpnkjnxs/image/upload/${imagePublicIds[index]}';
                return Stack(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () =>
                              onImageRemoved(imagePublicIds[index]),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        else
          Container(
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Chưa có ảnh nào được upload',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (showCameraButton) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: disabled ? null : uploadImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(isLoading.value ? 'Đang đợi...' : 'Chụp hình'),
                ),
              ),
            ],
            if (optionalButton != null) ...[
              if (showCameraButton) const SizedBox(width: 8),
              Expanded(child: optionalButton!),
            ],
          ],
        ),
      ],
    );
  }
}
