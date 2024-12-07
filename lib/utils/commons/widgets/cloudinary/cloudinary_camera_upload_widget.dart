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

  // Các thuộc tính để tùy chỉnh text overlay (có thể null)
  final String? overlayText;
  final String? fontFamily;
  final int? fontSize;
  final String? fontColor;
  final String? gravity;
  final int? yOffset;

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
    this.overlayText, // Optional
    this.fontFamily, // Optional
    this.fontSize, // Optional
    this.fontColor, // Optional
    this.gravity, // Optional
    this.yOffset, // Optional
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = useMemoized(() => ImagePicker());
    final isLoading = useState(false);
    final cloudinary = useMemoized(
        () => CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false));

    // Hàm tạo URL với transformation (nếu có)
    String getTransformedUrl(String secureUrl) {
      print("chekcing uri $secureUrl ");
      final uri = Uri.parse(secureUrl);
      final pathSegments = uri.pathSegments;

      // Tìm vị trí 'upload' trong pathSegments
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 1 >= pathSegments.length) {
        // Nếu không tìm thấy 'upload' hoặc thiếu phần sau, trả về URL gốc
        return secureUrl;
      }

      // Phần sau 'upload'
      final afterUpload = pathSegments.sublist(uploadIndex + 1);

      // Xây dựng transformation string
      final family = fontFamily ?? "Arial";
      final size = fontSize?.toString() ?? "20";
      final color = fontColor ?? "white";
      final posGravity = gravity ?? "south";
      final posYOffset = yOffset ?? 50;
      final overlay = Uri.encodeComponent(overlayText ?? "");

      // Định dạng transformation: l_text:<fontFamily>_<fontSize>_<fontColor>:<overlayText>,g_<gravity>
      final transformation =
          "l_text:${family}_${size}_$color:$overlay,g_$posGravity,y_$posYOffset";

      // Tạo lại pathSegments với transformation chèn vào
      final newPathSegments = [
        ...pathSegments.sublist(0, uploadIndex + 1),
        transformation,
        ...afterUpload,
      ];

      // Tạo lại URI với pathSegments mới
      final transformedUri = uri.replace(
        pathSegments: newPathSegments,
      );

      print("chekcing uri 2 ${transformedUri.toString()} ");
      return transformedUri.toString();
    }

    final checking =
        getTransformedUrl('movemate/q0dgjkd6y0ujkvqmgybl').toString();
    print("chekcing chekcing uri 3342 $checking");
    // Hàm upload hình ảnh từ camera
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

        print('Upload success: ${response.secureUrl}');

        // Tạo URL đã được thêm transformations
        final transformedUrl = getTransformedUrl(response.secureUrl);

        // In ra để kiểm tra
        print('Transformed URL: $transformedUrl');

        // Truyền transformedUrl và publicId qua callback
        onImageUploaded(
          transformedUrl,
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
        // Phần hiển thị hình ảnh đã upload
        if (imagePublicIds.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagePublicIds.length,
              itemBuilder: (context, index) {
                final publicId = imagePublicIds[index];
                final imageUrl = getTransformedUrl(publicId);
                print('checking image url 1: $imageUrl');
                print('checking image url 2: $publicId');
                print(
                    'checking image url 3: ${imagePublicIds[index].toString()}');
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
                            print('checking lỗi : $error ');
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

        // Phần button upload và optional button
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
