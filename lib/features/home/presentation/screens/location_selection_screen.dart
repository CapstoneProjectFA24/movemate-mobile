import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_selection_modal.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

final vietmapControllerProvider =
    StateProvider<VietmapController?>((ref) => null);

@RoutePage()
class LocationSelectionScreen extends HookConsumerWidget {
  const LocationSelectionScreen({super.key});

  static const String apiKey =
      '38db2f3d058b34e0f52f067fe66a902830fac1a044e8d444';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(vietmapControllerProvider);
    final lineState = useState<Line?>(null);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  VietmapGL(
                    styleString:
                        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey",
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(10.762317, 106.654551),
                      zoom: 15,
                    ),
                    onStyleLoadedCallback: () => debugPrint("Map style loaded"),
                    onMapCreated: (VietmapController controller) {
                      ref.read(vietmapControllerProvider.notifier).state =
                          controller;
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCustom(
                buttonText: "Chọn địa chỉ",
                isButtonEnabled: true,
                onButtonPressed: () =>
                    _showLocationSelectionModal(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSelectionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: AssetsConstants.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.7,
        child: LocationSelectionModal(ref: ref),
      ),
    );
  }
}
