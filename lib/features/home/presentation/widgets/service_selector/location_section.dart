import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/widgets/service_selector/location_selection.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationSection extends StatelessWidget {
  final String title;
  final LocationModel? location;
  final VoidCallback onTap;
  final bool hasError;
  final String errorMessage;

  const LocationSection({
    required this.title,
    required this.location,
    required this.onTap,
    required this.hasError,
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FadeInUp(
            child: LabelText(
              content: title,
              size: 16,
              fontFamily: 'bold',
              color: AssetsConstants.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationSelection(
              location: location,
              onTap: onTap,
              hasError: hasError,
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: LabelText(
                  content: errorMessage,
                  size: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
