import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/vinh/service_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class VehicleCard extends StatelessWidget {
  final ServiceEntity service;
  final bool isSelected;

  const VehicleCard({
    super.key,
    required this.service,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final truckCategory = service.truckCategory;
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 140,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AssetsConstants.greyColor.shade100,
            ),
            child: Image.network(
              service.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 50);
              },
            ),
          ),
          const SizedBox(width: 16),
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
                        '${truckCategory.estimatedLength} x ${truckCategory.estimatedWidth} x ${truckCategory.estimatedHeight} x ${truckCategory.maxLoad}',
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
                    'No Truck Category',
                    style: TextStyle(
                      fontSize: 12,
                      color: AssetsConstants.greyColor.shade700,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AssetsConstants.primaryDark,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
