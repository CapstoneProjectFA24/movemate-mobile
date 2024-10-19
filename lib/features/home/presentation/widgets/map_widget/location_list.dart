import 'package:flutter/material.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationList extends StatelessWidget {
  final List<LocationModel> locations;
  final Function(LocationModel) onLocationSelected;

  const LocationList({
    super.key,
    required this.locations,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return ListTile(
          leading:
              const Icon(Icons.location_on, color: AssetsConstants.primaryDark),
          title: Text(
            location.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AssetsConstants.blackColor,
            ),
          ),
          subtitle: Text(
            location.address,
            style: const TextStyle(
              fontSize: 12,
              color: AssetsConstants.greyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Text(
            location.distance,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          onTap: () => onLocationSelected(location),
        );
      },
    );
  }
}