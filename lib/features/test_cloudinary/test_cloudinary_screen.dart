import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_upload_widget.dart';

@RoutePage()
class TestCloudinaryScreen extends HookWidget {
  const TestCloudinaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Danh sách hình ảnh giả lập từ backend
    final images = useState<List<String>>([
      // "https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728483658/movemate/kv3nomfji9rtofok0wmo.jpg",  // 1
      // "https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728485337/movemate/g12muevg0sqpkboh232d.jpg"
    ]);
    print('Images: ${images.value}');

// Tách publicId từ danh sách hình ảnh   => cái này t fotmat từ images => 
// id riêng ví dụ :
        // https://res.cloudinary.com/dkpnkjnxs/image/upload/v1728483658/movemate/kv3nomfji9rtofok0wmo.jpg 
        // thành => movemate/kv3nomfji9rtofok0wmo
    final imagePublicIds = useState<List<String>>(
      images.value.map((url) {
        final uri = Uri.parse(url);
        final pathSegments = uri.pathSegments;
        return pathSegments.length > 1
            ? '${pathSegments[pathSegments.length - 2]}/${pathSegments.last.split('.').first}'
            : '';
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Cloudinary Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Image Upload Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ImageUploadWidget(
              imagePublicIds: imagePublicIds.value,
              onImageUploaded: (url, publicId) {
                print('Uploaded successfully: $url');
                print('Uploaded successfully: $publicId');
                // Cập nhật danh sách images bằng URL trả về  
                      //=> RỒI LƯU VÔ state images nè rồi khi PUT cập nhật thì gửi cái images mới lên flow api ấy hen chú TUẤN
                images.value = [...images.value, url];

                // Cập nhật danh sách publicIds
                imagePublicIds.value = [...imagePublicIds.value, publicId];

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image uploaded successfully: $url'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onImageRemoved: (publicId) {
                imagePublicIds.value =
                    imagePublicIds.value.where((id) => id != publicId).toList();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image removed: $publicId'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Uploaded Images: ${imagePublicIds.value.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
