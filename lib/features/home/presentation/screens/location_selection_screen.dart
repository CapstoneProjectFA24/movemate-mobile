import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:movemate/features/home/presentation/widgets/button_custom.dart';
import 'package:movemate/features/home/presentation/widgets/location_selection_modal.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class LocationSelectionScreen extends HookConsumerWidget {
  const LocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      body: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          const LabelText(content: "map is loading here", size: 16),
          // Location selection UI
          ButtonCustom(
            buttonText: "Chọn địa chỉ",
            isButtonEnabled: true,
            onButtonPressed: () => {
              _showLocationSelectionModal(context, ref),
            },
          )
        ],
      ),
    );
  }

  // Hàm hiển thị modal chọn địa điểm
  void _showLocationSelectionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: AssetsConstants.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Chiều cao modal bằng 1/2 màn hình
          child: LocationSelectionModal(ref: ref),
        );
      },
    );
  }
}
