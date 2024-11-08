import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class CleaningServiceScreen extends HookConsumerWidget {
  const CleaningServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bạn có thể sử dụng Riverpod để quản lý trạng thái nếu cần
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                // Hình ảnh nền
                Image.network(
                  'https://storage.googleapis.com/a1aa/image/cleaning_service_banner.jpg', // Thay bằng URL hình ảnh dịch vụ dọn nhà
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                // Nút quay lại
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.black,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                // Các biểu tượng
                Positioned(
                  top: 40,
                  right: 20,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.red,
                            size: 16,
                          ),
                          onPressed: () {
                            // Xử lý khi nhấn nút yêu thích
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.shareAlt,
                            color: Colors.black,
                            size: 16,
                          ),
                          onPressed: () {
                            // Xử lý khi nhấn nút chia sẻ
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Nội dung chính
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  const Text(
                    'Dọn Nhà Chuyên Nghiệp - Vincom Landmark Tower - 6170',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Chi tiết
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '10,0 km · Dịch Vụ Gia Đình',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 6,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Đang mở cửa · Đóng cửa lúc 22:00',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Các nút chức năng
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Xử lý khi nhấn nút Gọi
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.phone,
                            color: Colors.white,
                            size: 16,
                          ),
                          label: const Text(
                            'Gọi',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Xử lý khi nhấn nút Đặt xe
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.car,
                            color: Colors.white,
                            size: 16,
                          ),
                          label: const Text(
                            'Đặt xe',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Danh sách Voucher
                  const Text(
                    'Vouchers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Sử dụng ListView.builder trong Column bằng cách giới hạn chiều cao
                  SizedBox(
                    height: 200, // Điều chỉnh chiều cao phù hợp
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 2, // Số lượng voucher
                      itemBuilder: (context, index) {
                        return const VoucherCard(
                          imageUrl:
                              'https://storage.googleapis.com/a1aa/image/CfqjWfLkMAtogEu2MeIoKHJrHB3cPVR9b2IOfHNIvpGaBh6OB.jpg', // URL hình ảnh voucher
                          discount: 'Giảm 30%',
                          voucherTitle: 'Voucher 200.000₫ Cho Dịch Vụ Dọn Nhà',
                          discountedPrice: '140.000₫',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Phần chi tiết thêm
                  const Text(
                    'Chi tiết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Giờ phục vụ dọn nhà',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Thứ hai - Chủ nhật: 10:00am - 10:00pm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final String imageUrl;
  final String discount;
  final String voucherTitle;
  final String discountedPrice;

  const VoucherCard({
    super.key,
    required this.imageUrl,
    required this.discount,
    required this.voucherTitle,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Hình ảnh voucher
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            // Thông tin voucher
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Khuyến mãi
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Tiêu đề voucher
                  Text(
                    voucherTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Giá sau giảm
                  Text(
                    discountedPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Nút mua
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút Mua
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Mua',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
