// truck_item.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/test_cate_trucks/domain/entities/truck_entities.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class TruckItem extends StatefulWidget {
  const TruckItem({
    super.key,
    required this.truck,
    required this.onCallback,
  });

  final TruckEntities truck;
  final VoidCallback onCallback;

  @override
  _TruckItemState createState() => _TruckItemState();
}

class _TruckItemState extends State<TruckItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(AssetsConstants.defaultPadding - 12.0),
      margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        border: Border.all(color: AssetsConstants.subtitleColor),
        borderRadius: BorderRadius.circular(AssetsConstants.defaultBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content displayed initially
          InkWell(
            onTap: () {
              // Navigate to truck detail screen if needed
              // context.router.push(TruckDetailScreenRoute(truckId: widget.truck.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.truck.categoryName,
                  style: const TextStyle(
                    fontSize: AssetsConstants.defaultFontSize - 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Max Load: ${widget.truck.maxLoad} kg',
                  style: const TextStyle(
                    fontSize: AssetsConstants.defaultFontSize - 14.0,
                  ),
                ),

                Text(
                  widget.truck.summarize,
                  style: const TextStyle(
                    fontSize: AssetsConstants.defaultFontSize - 14.0,
                  ),
                ),
                // Divider
                SizedBox(height: size.height * 0.01),
                Container(
                  width: size.width,
                  height: 1,
                  color: AssetsConstants.subtitleColor,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          // Details button
          CustomButton(
            isOutline: true,
            size: AssetsConstants.defaultFontSize - 14.0,
            content: isExpanded
                ? 'Hide Details'.toUpperCase()
                : 'Details'.toUpperCase(),
            onCallback: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            isActive: true,
            width: size.width,
            height: size.height * 0.04,
            backgroundColor: AssetsConstants.whiteColor,
            contentColor: AssetsConstants.mainColor,
          ),
          // Expanded content
          if (isExpanded) ...[
            SizedBox(height: size.height * 0.01),
            Text(
              widget.truck.description,
              style: const TextStyle(
                fontSize: AssetsConstants.defaultFontSize - 14.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'Dimensions: ${widget.truck.estimatedLength} x ${widget.truck.estimatedWidth} x ${widget.truck.estimatedHeight} m',
              style: const TextStyle(
                fontSize: AssetsConstants.defaultFontSize - 14.0,
              ),
            ),
            // Add any other additional information you want to display when expanded
          ],
          SizedBox(height: size.height * 0.005),
        ],
      ),
    );
  }
}
