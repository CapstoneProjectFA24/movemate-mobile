import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_bottom_sheet.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/location_info_card.dart';
import 'package:movemate/services/map_services/location_service.dart';
import 'package:movemate/services/map_services/map_service.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? currentPosition;
  Line? currentRoute;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    initializeLocationGPS();
  }

  @override
  void dispose() {
    clearCurrentRoute();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> clearCurrentRoute() async {
    if (mapController != null) {
      await MapService.clearRoute(mapController!);
      currentRoute = null;
    }
  }

  Future<void> drawRouteBetweenLocations(Booking bookingState) async {
    if (mapController == null ||
        bookingState.pickUpLocation == null ||
        bookingState.dropOffLocation == null) {
      return;
    }

    await clearCurrentRoute();

    currentRoute = await MapService.drawRoute(
      controller: mapController!,
      origin: LatLng(
        bookingState.pickUpLocation!.latitude,
        bookingState.pickUpLocation!.longitude,
      ),
      destination: LatLng(
        bookingState.dropOffLocation!.latitude,
        bookingState.dropOffLocation!.longitude,
      ),
      routeColor: Colors.orange,
      routeWidth: 4.0,
    );
  }

  Future<void> initializeLocationGPS() async {
    if (await LocationService.checkLocationPermission()) {
      if (await LocationService.isLocationServiceEnabled()) {
        startLocationTracking();
      } else {
        LocationService.showEnableLocationDialog(context);
      }
    } else {
      LocationService.showPermissionDeniedDialog(context);
    }
  }

  void startLocationTracking() {
    setState(() => isTracking = true);

    LocationService.getPositionStream().listen((Position position) {
      setState(() => currentPosition = position);

      if (mapController != null) {
        MapService.focusOnLocation(
          mapController!,
          LatLng(position.latitude, position.longitude),
        );
      }
    });
  }

  List<Marker> buildMarkers(Booking bookingState) {
    final markers = <Marker>[];

    if (bookingState.pickUpLocation != null) {
      markers.add(
        Marker(
          alignment: Alignment.bottomCenter,
          child: const Icon(Icons.location_on, color: Colors.green, size: 50),
          latLng: LatLng(
            bookingState.pickUpLocation!.latitude,
            bookingState.pickUpLocation!.longitude,
          ),
        ),
      );
    }

    if (bookingState.dropOffLocation != null) {
      markers.add(
        Marker(
          alignment: Alignment.bottomCenter,
          child: const Icon(Icons.location_on, color: Colors.red, size: 50),
          latLng: LatLng(
            bookingState.dropOffLocation!.latitude,
            bookingState.dropOffLocation!.longitude,
          ),
        ),
      );
    }

    return markers;
  }

  List<LatLng> getLocations(Booking bookingState) {
    final locations = <LatLng>[];

    if (bookingState.pickUpLocation != null) {
      locations.add(LatLng(
        bookingState.pickUpLocation!.latitude,
        bookingState.pickUpLocation!.longitude,
      ));
    }

    if (bookingState.dropOffLocation != null) {
      locations.add(LatLng(
        bookingState.dropOffLocation!.latitude,
        bookingState.dropOffLocation!.longitude,
      ));
    }

    return locations;
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final markers = buildMarkers(bookingState);
    final locations = getLocations(bookingState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (locations.isNotEmpty && mapController != null) {
        MapService.focusOnAllMarkers(mapController!, locations);

        if (locations.length == 2) {
          drawRouteBetweenLocations(bookingState);
        }
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
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                        if (locations.isNotEmpty) {
                          MapService.focusOnAllMarkers(controller, locations);
                          if (locations.length == 2) {
                            drawRouteBetweenLocations(bookingState);
                          }
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
                  if (currentPosition != null)
                    Positioned(
                      bottom: 80,
                      left: 16,
                      child: LocationInfoCard(position: currentPosition!),
                    ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: MapActionButtons(
                      onMyLocationPressed: () {
                        if (currentPosition != null && mapController != null) {
                          MapService.focusOnLocation(
                            mapController!,
                            LatLng(currentPosition!.latitude,
                                currentPosition!.longitude),
                          );
                        }
                      },
                      showFocusAllMarkers: markers.length > 1,
                      onFocusAllMarkersPressed: markers.length > 1
                          ? () => MapService.focusOnAllMarkers(
                              mapController!, locations)
                          : null,
                      showDrawRoute: locations.length == 2,
                      onDrawRoutePressed: locations.length == 2
                          ? () => drawRouteBetweenLocations(bookingState)
                          : null,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        context.router.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCustom(
                buttonText: (bookingState.dropOffLocation != null &&
                        bookingState.pickUpLocation != null)
                    ? "Chọn lại địa chỉ"
                    : "Chọn địa chỉ",
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