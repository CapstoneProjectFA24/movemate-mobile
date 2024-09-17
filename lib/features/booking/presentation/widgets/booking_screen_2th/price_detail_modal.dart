import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PriceDetailModal extends StatelessWidget {
  final double totalPrice;

  const PriceDetailModal({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: AssetsConstants.whiteColor, // Đặt màu nền trắng cho modal
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.5, // Giới hạn chiều cao modal
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi tiết giá',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AssetsConstants.blackColor,
                ),
              ),
              const SizedBox(height: 2),
              _buildPriceDetailRow('Phí giao hàng', 282900),
              _buildPriceDetailRow(
                  'Dịch Vụ Bốc Xếp - Bốc Xếp Tận Nơi (Bởi tài xế)', 140000),
              _buildPriceDetailRow(
                  'Dịch Vụ Bốc Xếp - Bốc Xếp Tận Nơi (Có người hỗ trợ)',
                  400000),
              _buildPriceDetailRow(
                  'Dịch Vụ Bốc Xếp - Bốc Xếp Dưới Xe (Có người hỗ trợ)',
                  350000),
              _buildPriceDetailRow('Giao Hàng 2 Chiều', 172200),
              _buildPriceDetailRow('Giao Hàng Siêu Tốc', 49200),
              _buildPriceDetailRow('Hỗ Trợ Phí Cầu Đường', 100000),
              _buildPriceDetailRow('Thuế GTGT', 119544),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₫${totalPrice.toStringAsFixed(3)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AssetsConstants.blackColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AssetsConstants.green1, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Phí giao hàng rẻ hơn ₫36.900. Đừng bỏ lỡ!',
                      style: TextStyle(
                          color: AssetsConstants.green1, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Chưa bao gồm phí cầu đường và phí phụ ngoài. Vui lòng thoả thuận với tài xế hoặc kiểm tra kỹ càng.',
                style: TextStyle(
                    fontSize: 12, color: AssetsConstants.greyColor.shade600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // Để nút rộng bằng màn hình
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AssetsConstants.primaryDark, // Màu nền cam
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Bo góc nút
                    ),
                  ),
                  child: const Text(
                    'Bước tiếp theo',
                    style: TextStyle(
                      fontSize: 16, // Kích thước chữ
                      fontWeight: FontWeight.bold, // Chữ in đậm
                      color: AssetsConstants.whiteColor, // Màu chữ trắng
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper để hiển thị từng dòng chi tiết giá
  Widget _buildPriceDetailRow(String title, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis, // Thêm để tránh text bị tràn
              maxLines: 2,
            ),
          ),
          const SizedBox(
            width: 28,
          ),
          Text(
            '₫${price.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
