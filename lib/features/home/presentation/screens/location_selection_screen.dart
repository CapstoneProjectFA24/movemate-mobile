import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_bottom_sheet.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/constants/api_constant.dart';

final vietmapControllerProvider = Provider<VietmapController?>((ref) => null);

@RoutePage()
class LocationSelectionScreen extends ConsumerStatefulWidget {
  const LocationSelectionScreen({super.key});

  static const String apiKey = APIConstants.apiVietMapKey;

  @override
  ConsumerState<LocationSelectionScreen> createState() =>
      LocationSelectionScreenState();
}

class LocationSelectionScreenState
    extends ConsumerState<LocationSelectionScreen> {
  VietmapController? mapController;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void focusOnLocation(LatLng location) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 15),
    );
  }

  void focusOnAllMarkers(List<LatLng> locations) {
    if (locations.isEmpty || mapController == null) return;

    if (locations.length == 1) {
      focusOnLocation(locations.first);
      return;
    }

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var location in locations) {
      minLat = math.min(minLat, location.latitude);
      maxLat = math.max(maxLat, location.latitude);
      minLng = math.min(minLng, location.longitude);
      maxLng = math.max(maxLng, location.longitude);
    }

    final latPadding = (maxLat - minLat) * 0.1;
    final lngPadding = (maxLng - minLng) * 0.1;

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - latPadding, minLng - lngPadding),
          northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
        ),
        left: 50,
        top: 50,
        right: 50,
        bottom: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    List<Marker> markers = [];
    List<LatLng> locations = [];

    // Thêm điểm đón
    if (bookingState.pickUpLocation != null) {
      final pickupLatLng = LatLng(
        bookingState.pickUpLocation!.latitude,
        bookingState.pickUpLocation!.longitude,
      );
      locations.add(pickupLatLng);
      markers.add(
        Marker(
          alignment: Alignment.bottomCenter,
          child: const Icon(
            Icons.location_on,
            color: Colors.green,
            size: 50,
          ),
          latLng: pickupLatLng,
        ),
      );
    }

    // Thêm điểm đến
    if (bookingState.dropOffLocation != null) {
      final dropoffLatLng = LatLng(
        bookingState.dropOffLocation!.latitude,
        bookingState.dropOffLocation!.longitude,
      );
      locations.add(dropoffLatLng);
      markers.add(
        Marker(
          alignment: Alignment.bottomCenter,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 50,
          ),
          latLng: dropoffLatLng,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (locations.isNotEmpty) {
        focusOnAllMarkers(locations);
      }
    });

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
                        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=${LocationSelectionScreen.apiKey}",
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(10.762317, 106.654551),
                      zoom: 15,
                    ),
                    onStyleLoadedCallback: () => debugPrint("Map style loaded"),
                    onMapCreated: (VietmapController controller) {
                      setState(() {
                        mapController = controller;
                        if (locations.isNotEmpty) {
                          focusOnAllMarkers(locations);
                        }
                      });
                    },
                  ),
                  if (mapController != null && markers.isNotEmpty)
                    MarkerLayer(
                      ignorePointer: true,
                      mapController: mapController!,
                      markers: markers,
                    ),
                  if (markers.length > 1)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () => focusOnAllMarkers(locations),
                        child: const Icon(Icons.center_focus_strong),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCustom(
                buttonText: "Chọn địa chỉ",
                isButtonEnabled: mapController != null,
                onButtonPressed: () {
                  if (mapController != null) {
                    showModalBottomSheet(
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
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
