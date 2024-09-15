import 'package:flutter/material.dart';
import 'package:movemate/features/order/data/models/order_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class DriverArrivedSection extends StatelessWidget {
  final OrderDriverArrivedSectionModels driverArrive;

  const DriverArrivedSection({
    super.key,
    required this.driverArrive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AssetsConstants.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.delivery_dining,
                    color: AssetsConstants.primaryLight, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tài xế đang đến',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AssetsConstants.primaryLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(driverArrive.driverImage
                    .toString()), // Replace with driver image
              ),
              title: Text(driverArrive.driverName ?? 'Unknown',
                  style: const TextStyle(fontSize: 16)),
              subtitle: Text(
                  '${driverArrive.driverRating ?? "5.0"} ★ | ${driverArrive.driverLicensePlate ?? "Unknown"}'),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // Add call driver functionality
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
