// vehicle_card.dart
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// vehicle_card.dart// vehicle_card.dart
class VehicleCard extends StatelessWidget {
  final InverseParentServiceEntity service;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final truckCategory = service.truckCategory;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? AssetsConstants.primaryLight.withOpacity(0.2)
              : AssetsConstants.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AssetsConstants.primaryDark
                : AssetsConstants.greyColor.shade300,
            width: 2,
          ),
        ),
        height: 140,
        width: double.infinity,
        child: Row(
          children: [
            // Vehicle Image
            SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                service.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 50);
                },
              ),
            ),
            const SizedBox(width: 16),
            // Vehicle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AssetsConstants.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AssetsConstants.greyColor.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (truckCategory != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          size: 16,
                          color: AssetsConstants.blackColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          truckCategory.categoryName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AssetsConstants.blackColor,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.straighten,
                          size: 16,
                          color: AssetsConstants.blackColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${truckCategory.estimatedLenght ?? ''} x ${truckCategory.estimatedWidth} x ${truckCategory.estimatedHeight}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AssetsConstants.blackColor,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      'Không có thông tin loại xe',
                      style: TextStyle(
                        fontSize: 12,
                        color: AssetsConstants.greyColor.shade700,
                      ),
                    ),
                ],
              ),
            ),
            // Selection Icon
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AssetsConstants.primaryDark,
              ),
          ],
        ),
      ),
    );
  }
}
