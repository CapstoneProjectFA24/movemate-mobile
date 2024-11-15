import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/tracking_map_item/chat_screen.dart';
import 'package:movemate/features/order/presentation/widgets/tracking_map_item/status_bottom_sheet.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

@RoutePage()
class TrackingMap extends StatefulWidget {
  final String staffId;
  final String role;
  final OrderEntity job;

  const TrackingMap({
    super.key,
    required this.staffId,
    required this.role,
    required this.job,
  });

  static const String apiKey = APIConstants.apiVietMapKey;

  @override
  State<StatefulWidget> createState() => TrackingMapState();
}

class TrackingMapState extends State<TrackingMap> {
  MapNavigationViewController? _navigationController;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();

  // Staff location tracking
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  LatLng? _staffLocation;

  // Map state
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initNavigation();
    _initStaffTracking();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> _initNavigation() async {
    if (!mounted) return;
    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.apiKey = APIConstants.apiVietMapKey;
    _navigationOption.mapStyle =
        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=${APIConstants.apiVietMapKey}";
    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  void _buildInitialRoute() async {
    if (_navigationController != null && _staffLocation != null) {
      List<String> pickupPointCoordinates = widget.job.pickupPoint.split(',');
      LatLng pickupPoint = LatLng(
        double.parse(pickupPointCoordinates[0].trim()),
        double.parse(pickupPointCoordinates[1].trim()),
      );

      if (_staffLocation != null) {
        _navigationController?.buildRoute(
          waypoints: [_staffLocation!, pickupPoint],
          profile: DrivingProfile.cycling,
        ).then((success) {
          if (!success) {
            print('Failed to build route');
          }
        }).catchError((error) {
          print('Error building route: $error');
        });
      } else {
        print('Invalid staff location or delivery point');
      }
    } else {
      print('_navigationController or _staffLocation is null');
    }
  }

  void _initStaffTracking() {
    final String bookingId = widget.job.id.toString();
    DatabaseReference staffLocationRef = FirebaseDatabase.instance
        .ref()
        .child('tracking_locations/81/DRIVER/61');
    // DatabaseReference staffLocationRef = FirebaseDatabase.instance.ref().child(
    //     'tracking_locations/$bookingId/${widget.role}/${widget.staffId}');

    _locationSubscription = staffLocationRef.onValue.listen((event) {
      if (!mounted) return;

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double lat = data['lat'] as double;
        final double long = data['long'] as double;

        setState(() {
          _staffLocation = LatLng(lat, long);
          _updateStaffLocation();
        });
      }
    });
  }

  void _updateStaffLocation() {
    if (_staffLocation == null ||
        !_isMapReady ||
        _navigationController == null) {
      return;
    }

    // Update camera to follow staff
    _navigationController?.animateCamera(
      latLng: _staffLocation!,
      zoom: 15,
      duration: const Duration(milliseconds: 1000),
    );

    _buildInitialRoute();
  }

  @override
  Widget build(BuildContext context) {
    List<String> pickupPointCoordinates = widget.job.pickupPoint.split(',');
    LatLng pickupPoint = LatLng(
      double.parse(pickupPointCoordinates[0].trim()),
      double.parse(pickupPointCoordinates[1].trim()),
    );

    return Scaffold(
        appBar: const CustomAppBar(
          title: "Theo dõi tiến trình",
          backButtonColor: AssetsConstants.whiteColor,
          backgroundColor: AssetsConstants.mainColor,
        ),
        body: Stack(
          children: [
            NavigationView(
              mapOptions: _navigationOption,
              onMapCreated: (controller) {
                setState(() {
                  _navigationController = controller;
                  _isMapReady = true;
                });

                if (_staffLocation != null) {
                  _updateStaffLocation();
                } else {
                  controller.buildRoute(
                    waypoints: [pickupPoint, pickupPoint],
                    profile: DrivingProfile.cycling,
                  ).then((success) {
                    if (!success) {
                      print('Failed to build initial route');
                    }
                  }).catchError((error) {
                    print('Error building initial route: $error');
                  });
                }
              },
            ),
            if (_staffLocation == null)
              const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Waiting for staff location updates...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: TrackingMapBottomSheet(
                job: widget.job,
              ),
            ),
            Positioned(
              bottom: 220,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.chat),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    if (_navigationController != null) {
      _navigationController!.onDispose();
    }
    super.dispose();
  }
}