import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/constants/api_constant.dart';

import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

@RoutePage()
class TrackingMap extends StatefulWidget {
  final String staffId;
  final List<String> staffIds;
  final String role;
  final OrderEntity job;

  const TrackingMap({
    super.key,
    required this.staffId,
    required this.staffIds,
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
    _initNavigation();
    _initStaffTracking();
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

  void _initStaffTracking() {
    final String bookingId = widget.job.id.toString();
    DatabaseReference staffLocationRef = FirebaseDatabase.instance
        .ref()
        .child('tracking_locations/34/DRIVER/61');
    // DatabaseReference staffLocationRef = FirebaseDatabase.instance.ref().child(
    //     'tracking_locations/$bookingId/${widget.role}/${widget.staffId}');

    print("log 1");
    _locationSubscription = staffLocationRef.onValue.listen((event) {
      if (!mounted) return;
      print("log 2");

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double lat = data['lat'] as double;
        final double long = data['long'] as double;
        print("log 3 $data");

        setState(() {
          _staffLocation = LatLng(lat, long);
          _updateStaffLocation();
        });
      }
    });
  }

  void _updateStaffLocation() {
    if (_staffLocation == null || !_isMapReady || _navigationController == null)
      return;

    // Update camera to follow staff
    _navigationController?.animateCamera(
      latLng: _staffLocation!,
      zoom: 15,
      duration: const Duration(milliseconds: 1000),
    );

    // Build route from staff location to delivery point
    List<String> deliveryPointCoordinates = widget.job.deliveryPoint.split(',');
    LatLng deliveryPoint = LatLng(
      double.parse(deliveryPointCoordinates[0].trim()),
      double.parse(deliveryPointCoordinates[1].trim()),
    );

    _navigationController?.buildRoute(
      waypoints: [_staffLocation!, deliveryPoint],
      profile: DrivingProfile.cycling,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get delivery point coordinates for initial position
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

              // Build initial route to delivery point
              if (_staffLocation != null) {
                _updateStaffLocation();
              } else {
                // If staff location is not yet available, just show the delivery point
                controller.buildRoute(
                  waypoints: [deliveryPoint, deliveryPoint],
                  profile: DrivingProfile.cycling,
                );
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
