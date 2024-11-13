import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/constants/api_constant.dart';
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
      List<String> deliveryPointCoordinates =
          widget.job.deliveryPoint.split(',');
      LatLng deliveryPoint = LatLng(
        double.parse(deliveryPointCoordinates[0].trim()),
        double.parse(deliveryPointCoordinates[1].trim()),
      );

      if (_staffLocation != null) {
        _navigationController?.buildRoute(
          waypoints: [_staffLocation!, deliveryPoint],
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
        .child('tracking_locations/34/DRIVER/61');
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
    List<String> deliveryPointCoordinates = widget.job.deliveryPoint.split(',');
    LatLng deliveryPoint = LatLng(
      double.parse(deliveryPointCoordinates[0].trim()),
      double.parse(deliveryPointCoordinates[1].trim()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Delivery'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
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
                  waypoints: [deliveryPoint, deliveryPoint],
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
        ],
      ),
    );
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
