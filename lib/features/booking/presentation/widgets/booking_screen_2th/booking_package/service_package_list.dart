// service_package_list.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/service_package_tile.dart';

class ServicePackageList extends StatelessWidget {
  final List<ServicesPackageEntity> servicePackages;

  const ServicePackageList({Key? key, required this.servicePackages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make a copy of the list to avoid modifying the original
    List<ServicesPackageEntity> sortedPackages = List.from(servicePackages);

    // Sort the list
    sortedPackages.sort((a, b) {
      bool aHasSubServices =
          a.inverseParentService != null && a.inverseParentService.isNotEmpty;
      bool bHasSubServices =
          b.inverseParentService != null && b.inverseParentService.isNotEmpty;

      if (aHasSubServices && !bHasSubServices) {
        return -1;
      } else if (!aHasSubServices && bHasSubServices) {
        return 1;
      } else {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: sortedPackages.length,
      itemBuilder: (context, index) {
        final servicePackage = sortedPackages[index];
        return ServicePackageTile(servicePackage: servicePackage);
      },
    );
  }
}
