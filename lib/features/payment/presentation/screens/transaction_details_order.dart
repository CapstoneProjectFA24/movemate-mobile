import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class TransactionDetailsOrder extends ConsumerWidget {
  const TransactionDetailsOrder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      body: Container(
        child: Container(
          width: 350, 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(FontAwesomeIcons.arrowLeft, color: Colors.red),
                      Text(
                        'Chi tiết đơn hàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(FontAwesomeIcons.questionCircle, color: Colors.red),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'đang chờ revewer đến',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'MoveMate ',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: 'sẽ gửi thông tin tài xế đến bạn',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'khi tìm thấy tài xế phù hợp',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      // Illustration
                      Center(
                        child: Image.network(
                          'https://storage.googleapis.com/a1aa/image/XXWSx2XNlVL5HR4Ne3UfiT7XzEyK6UBPWer41Y5trJgkMgQnA.jpg',
                          width: 64,
                          height: 64,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Icons
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(FontAwesomeIcons.utensils, color: Colors.red),
                          Icon(FontAwesomeIcons.mapMarkerAlt, color: Colors.red),
                          Icon(FontAwesomeIcons.truck, color: Colors.red),
                          Icon(FontAwesomeIcons.ellipsisH, color: Colors.red),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'ShopeeFood sẽ thông báo khi đơn bắt đầu được giao đến bạn.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 32),
                      // From Section
                      const Text(
                        'Từ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Đồ ăn | Bún Đậu Mắm Tôm Cụ Tí - Ăn Vặt - 306 Huỳnh Văn Lũy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '306 Huỳnh Văn Lũy, P. Phú Lợi, Thị xã Thủ Dầu Một, Bình Dương',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      // To Section
                      const Text(
                        'Đến',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '236 Đường DX027, Phú Mỹ, Thủ Dầu Một, Bình Dương, Việt Nam',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Phương - 0927523688',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 32),
                      // Order Details
                      const Text(
                        'Chi tiết đơn hàng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thanh toán',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(FontAwesomeIcons.chevronDown),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Trả qua tiền mặt 78.000 - 90.000đ',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mã đơn hàng: 544455',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '22/08/2024 | 15:15',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      // Distance and Vehicle Type
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '10,2 km',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Xe tải 1000kg',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Cancel Button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Hủy đặt xe',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
