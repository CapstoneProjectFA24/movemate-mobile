// summary_section.dart

import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'price_detail_modal.dart'; // Import your modal component

class SummarySection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPlaceOrder;
  final String buttonText; // Customizable button text
  final String priceLabel; // Customizable price label
  final Widget? priceDetailModal; // Customizable modal widget

  const SummarySection({
    super.key,
    required this.totalPrice,
    required this.onPlaceOrder,
    this.buttonText = 'Đặt đơn',
    this.priceLabel = 'Tổng giá',
    this.priceDetailModal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AssetsConstants.whiteColor,
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts the height to fit content
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      priceLabel,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _showInfoModal(context),
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AssetsConstants.greyColor.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${totalPrice.toStringAsFixed(0)}₫',
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AssetsConstants.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the modal
  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return priceDetailModal ??
            PriceDetailModal(
                totalPrice: totalPrice); // Use provided modal or default
      },
    );
  }
}
