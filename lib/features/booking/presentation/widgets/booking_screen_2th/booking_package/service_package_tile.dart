import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/utils/constants/asset_constant.dart'; // Import for AssetsConstants

class ServicePackageTile extends StatefulWidget {
  final ServicesPackageEntity servicePackage;
  const ServicePackageTile({super.key, required this.servicePackage});

  @override
  _ServicePackageTileState createState() => _ServicePackageTileState();
}

class _ServicePackageTileState extends State<ServicePackageTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Uncomment if you want margin and decoration
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() => _isExpanded = expanded);
        },
        title: Text(
          widget.servicePackage.name.trim(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          widget.servicePackage.description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.servicePackage.discountRate > 0)
              Container(
              
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${widget.servicePackage.discountRate}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: _isExpanded
                  ? AssetsConstants.greyColor
                  : AssetsConstants.primaryDark,
              size: 60,
            ),
          ],
        ),
        children: widget.servicePackage.inverseParentService.map((subService) {
          return SubServiceTile(subService: subService);
        }).toList(),
      ),
    );
  }
}
