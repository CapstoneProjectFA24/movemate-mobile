import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'price_detail_modal.dart'; // Import modal component

class SummarySection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPlaceOrder;
  const SummarySection({
    super.key,
    required this.totalPrice,
    required this.onPlaceOrder,
  });


  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AssetsConstants.whiteColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Tổng giá',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4), // Khoảng cách giữa chữ và icon
                  GestureDetector(
                    onTap: () =>
                        _showInfoModal(context), // Mở modal khi click vào icon
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AssetsConstants
                          .greyColor.shade600, // Màu xám nhạt cho icon
                    ),
                  ),
                ],
              ),
              Text(
                '${totalPrice.toStringAsFixed(3)}₫',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AssetsConstants.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPlaceOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AssetsConstants.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Bo tròn các góc button
                ),
              ),
              child: const Text(
                'Đặt đơn',
                style:
                    TextStyle(fontSize: 16, color: AssetsConstants.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm mở modal
  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return PriceDetailModal(totalPrice: totalPrice); // Gọi component modal
      },
    );
  }
}
