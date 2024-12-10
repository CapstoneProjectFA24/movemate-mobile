// summary_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'price_detail_modal.dart'; // Import your modal component

class SummarySection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPlacePress;
  final String buttonText; // Customizable button text
  final bool buttonIcon; // Customizable button text
  final String priceLabel; // Customizable price label
  final Widget? priceDetailModal; // Customizable modal widget
  final bool isButtonEnabled;
  final VoidCallback? onConfirm;

  const SummarySection({
    super.key,
    this.totalPrice = 0,
    required this.onPlacePress,
    required this.buttonText,
    required this.buttonIcon,
    required this.isButtonEnabled,
    this.priceLabel = 'Tổng giá',
    this.priceDetailModal,
    this.onConfirm,
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
                    if (buttonIcon)
                      GestureDetector(
                        onTap: () => showInfoModal(context),
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AssetsConstants.greyColor.shade600,
                        ),
                      ),
                  ],
                ),
                if (priceLabel != '')
                  LabelText(
                    content: '  ${formatPrice(totalPrice.toDouble())}',
                    size: 18,
                    fontWeight: FontWeight.bold,
                    color: AssetsConstants.primaryDark,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? onPlacePress : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? AssetsConstants.primaryDark
                      : AssetsConstants.greyColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
  void showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        if (priceDetailModal != null) {
          // If a custom modal is provided, use it
          return priceDetailModal!;
        } else {
          // Otherwise, use the default PriceDetailModal and pass onConfirm
          return PriceDetailModal(
            onConfirm: onConfirm ?? () => Navigator.pop(context),
          );
        }
      },
    );
  }
}
