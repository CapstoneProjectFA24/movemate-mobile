import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


@RoutePage()
class VoucherScreen extends HookConsumerWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () {
            // Xử lý khi nhấn nút back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vouchers gần tôi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const FiltersBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 10, // Số lượng VoucherCard bạn muốn hiển thị
              itemBuilder: (context, index) {
                return const VoucherCard(
                  imageUrl:
                      'https://cdn.pixabay.com/photo/2020/09/03/01/42/truck-5539960_960_720.png', // Thay thế bằng URL hình ảnh dịch vụ dọn nhà
                  title: 'Dọn Nhà Chuyên Nghiệp',
                  distance: '5 km',
                  category: 'Dịch Vụ Gia Đình',
                  rating: 4.8,
                  ratingCount: 200,
                  discount: '20% T2-CN',
                  voucherTitle: 'Voucher 100.000₫ Cho Dịch Vụ Dọn Nhà',
                  originalPrice: '100.000₫',
                  discountedPrice: '80.000₫',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FiltersBar extends StatelessWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Bạn có thể sử dụng Riverpod để quản lý trạng thái của các bộ lọc
    // Ví dụ: chọn bộ lọc nào đang được active
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // Thay đổi từ spaceAround thành start
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FilterButton(
              icon: FontAwesomeIcons.slidersH,
              label: 'Lọc theo',
              onPressed: null, // Cập nhật callback nếu cần
            ),

            FilterButton(
              icon: FontAwesomeIcons.tags,
              label: 'Khuyến mãi',
              onPressed: null,
            ),
            // Thêm các nút lọc khác nếu cần
            FilterButton(
              icon: FontAwesomeIcons.home,
              label: 'Dọn Nhà',
              onPressed: null,
            ),
            FilterButton(
              icon: FontAwesomeIcons.car,
              label: 'Xe',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const FilterButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () {}, // Đảm bảo onPressed không phải null
        icon: FaIcon(
          icon,
          size: 16,
          color: Colors.black,
        ),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          elevation: 0,
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String distance;
  final String category;
  final double? rating;
  final int? ratingCount;
  final String discount;
  final String voucherTitle;
  final String originalPrice;
  final String discountedPrice;

  const VoucherCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.distance,
    required this.category,
    this.rating,
    this.ratingCount,
    required this.discount,
    required this.voucherTitle,
    required this.originalPrice,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          // Nội dung
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Thêm ellipsis nếu quá dài
                ),
                const SizedBox(height: 5),
                // Thông tin phụ
                Row(
                  children: [
                    if (rating != null && ratingCount != null) ...[
                      const FaIcon(
                        FontAwesomeIcons.star,
                        color: Color(0xFFFFCC00),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$rating ($ratingCount)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis, // Thêm ellipsis
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      // Sử dụng Expanded để Text không vượt quá
                      child: Text(
                        '$distance · $category',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Giá và Khuyến mãi
                Row(
                  children: [
                    // Khuyến mãi
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis, // Thêm ellipsis
                      ),
                    ),
                    const Spacer(),
                    // Giá
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          voucherTitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          discountedPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
