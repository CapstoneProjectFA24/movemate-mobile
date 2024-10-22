import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_bottom_sheet.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  VietmapGL(
                    trackCameraPosition: true,
                    myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                    myLocationEnabled: true,
                    myLocationRenderMode: MyLocationRenderMode.COMPASS,
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

                  //bug

                  // if (mapController != null)
                  //   MarkerLayer(
                  //     ignorePointer: true,
                  //     mapController: mapController,
                  //     markers: [
                  //       Marker(
                  //         alignment: Alignment.bottomCenter,
                  //         child: const Icon(Icons.location_on,
                  //             color: Colors.red, size: 50),
                  //         latLng: const LatLng(10.762317, 106.654551),
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCustom(
                buttonText: "Chọn địa chỉ",
                isButtonEnabled: true,
                onButtonPressed: () => showModalBottomSheet(
                  backgroundColor: AssetsConstants.whiteColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => const FractionallySizedBox(
                    heightFactor: 0.7,
                    child: LocationBottomSheet(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
