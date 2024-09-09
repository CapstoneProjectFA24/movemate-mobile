import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_model.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PromotionDetails extends HookConsumerWidget {
  final Promotion promotion;

  const PromotionDetails({super.key, required this.promotion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Details'),
        backgroundColor: promotion.bgcolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promotion Image and Discount Info
              buildPromotionHeaderCard(),
              const SizedBox(height: 16),
              // Promotion Description
              Text(
                'Get a Discount up to ${promotion.discount} on domestic flights, maximum discount \$${promotion.minTransaction}.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Save big with a maximum discount of \$${promotion.minTransaction}. Take advantage of this fantastic opportunity to explore more while spending less on your travel expenses.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              // Refined Promo Details Card
              buildDetailCard(),
              const SizedBox(height: 16),
              // Voucher Code Section
              const Text(
                'Voucher Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(promotion.code,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: promotion.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Promo code copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Copy Code Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: promotion.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Promo code copied to clipboard!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: promotion.bgcolor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      const Text('Copy code', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the promotion header card
  Widget buildPromotionHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: AssetsConstants.blue2, // Background color of the card
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      padding: const EdgeInsets.all(16.0), // Padding inside the card
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Text information
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promotion.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AssetsConstants.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promotion.discount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AssetsConstants.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promotion.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AssetsConstants.blackColor,
                  ),
                ),
                const SizedBox(height: 12),
                // Voucher label
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8), // Padding for label
                  decoration: BoxDecoration(
                    color: AssetsConstants
                        .whiteColor, // Background color for the label
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_offer,
                          size: 14, color: AssetsConstants.blue1),
                      const SizedBox(width: 4),
                      Text(
                        promotion.code,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AssetsConstants.blue1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right side: Image
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners for image
              child: Image.asset(
                promotion.imagePath,
                fit: BoxFit.cover,
                height: 100, // Fixed height to maintain aspect ratio
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build the refined detail card layout
  Widget buildDetailCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                detailItem('Promo Period', promotion.promoPeriod),
                detailItem('Min. Transaction', '\$${promotion.minTransaction}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                detailItem('Type', promotion.type),
                detailItem('Destination', promotion.destination),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each detail item row
  Widget detailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                TextStyle(fontSize: 14, color: AssetsConstants.greyColor[400]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
