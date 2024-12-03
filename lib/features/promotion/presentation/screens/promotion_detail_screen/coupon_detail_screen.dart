import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class CouponDetailScreen extends HookConsumerWidget {
  final PromotionEntity promotion;

  const CouponDetailScreen({
    super.key,
    required this.promotion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Mã giảm giá'),
        backgroundColor: AssetsConstants.primaryMain,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image and other elements in the stack
          _buildHeader(),
          Positioned(
            left: 16,
            right: 16,
            top: 80,
            child: _buildCouponInfo(),
          ),
          // Scrollable content
          SingleChildScrollView(
            padding:
                const EdgeInsets.only(bottom: 100), // Add space for the button
            child: Padding(
              padding: const EdgeInsets.only(top: 240, right: 10, left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Hạn sử dụng mã',
                    content: '4 Th12 2024 00:00 - 4 Th12 2024 23:59',
                  ),
                  _buildSection(
                    title: 'Ưu đãi',
                    content:
                        'Lượt sử dụng có hạn. Nhanh tay kẻo lỡ bạn nhé! Giảm 12% Đơn tối thiểu đ1tr Giảm tới đa đ200k',
                  ),
                  _buildSection(
                    title: 'Áp dụng cho sản phẩm',
                    content:
                        'Chỉ áp dụng trên App cho một số sản phẩm và một số người dùng tham gia chương trình khuyến mãi nhất định.',
                  ),
                  _buildSection(
                    title: 'Phương thức thanh toán',
                    content: 'Mọi hình thức thanh toán',
                  ),
                  _buildSection(
                    title: 'Thiết bị',
                    content: 'iOS, Android',
                  ),
                  _buildSection(
                    title: 'Điều kiện',
                    content: 'Chỉ áp dụng cho một số khách hàng mới',
                  ),
                ],
              ),
            ),
          ),
          // Always at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildAcceptButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/bg_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coupon image with rounded corners and shadow
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1731511719/movemate_logo_e6f1lk.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Giảm 12% Giảm tới đa đ200k',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Đơn tối thiểu đ1tr',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade500,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Đồng ý'),
      ),
    );
  }
}
