import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServicePackageTile extends StatefulWidget {
  final ServicesPackageEntity servicePackage;

  const ServicePackageTile({
    super.key,
    required this.servicePackage,
  });

  @override
  _ServicePackageTileState createState() => _ServicePackageTileState();
}

class _ServicePackageTileState extends State<ServicePackageTile> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    if (widget.servicePackage.inverseParentService.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: FaIcon(
                  _isExpanded
                      ? FontAwesomeIcons.circleChevronDown
                      : FontAwesomeIcons.circleChevronUp,
                  color: _isExpanded
                      ? AssetsConstants.greyColor
                      : AssetsConstants.primaryDark,
                  size: 20,
                ),
              ),
            ],
          ),
          children:
              widget.servicePackage.inverseParentService.map((subService) {
            return SubServiceTile(subService: subService);
          }).toList(),
        ),
      );
    } else {
      return Consumer(builder: (context, ref, _) {
        final bookingNotifier = ref.read(bookingProvider.notifier);
        final bookingState = ref.watch(bookingProvider);

        final currentPackage = bookingState.selectedPackages.firstWhere(
          (p) => p.id == widget.servicePackage.id,
          orElse: () => widget.servicePackage.copyWith(quantity: 0),
        );

        final int quantity = currentPackage.quantity ?? 0;

        return Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              widget.servicePackage.name.trim(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.servicePackage.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: ServiceTrailingWidget(
              quantity: quantity,
              addService: true,
              onQuantityChanged: (newQuantity) {
                bookingNotifier.updateServicePackageQuantity(
                    widget.servicePackage, newQuantity);
                bookingNotifier.calculateAndUpdateTotalPrice();
              },
            ),
          ),
        );
      });
    }
  }
}
