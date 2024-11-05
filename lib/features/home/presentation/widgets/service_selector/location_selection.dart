import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationSelection extends StatelessWidget {
  final LocationModel? location;
  final VoidCallback onTap;
  final bool hasError;
  final VoidCallback? onClear;

  const LocationSelection({
    required this.location,
    required this.onTap,
    required this.hasError,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: FadeInRight(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasError ? Colors.red : AssetsConstants.primaryMain,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.add_location_outlined,
                    color: hasError ? Colors.red : AssetsConstants.primaryMain,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location?.address ?? 'Chọn địa điểm',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            hasError ? Colors.red : AssetsConstants.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // Add a spacer for the X button
                  if (location != null) const SizedBox(width: 26),
                ],
              ),
            ),
          ),
        ),
        if (location != null)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: hasError ? Colors.red : AssetsConstants.blackColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
