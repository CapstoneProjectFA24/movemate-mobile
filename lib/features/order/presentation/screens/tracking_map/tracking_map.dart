import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/tracking_map_item/chat_screen.dart';
import 'package:movemate/features/order/presentation/widgets/tracking_map_item/status_bottom_sheet.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
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
  RouteProgressEvent? routeProgressEvent;
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

  LatLng _getPickupPointLatLng() {
    final pickupPointCoordinates = widget.job.pickupPoint.split(',');
    return LatLng(
      double.parse(pickupPointCoordinates[0].trim()),
      double.parse(pickupPointCoordinates[1].trim()),
    );
  }

  LatLng _getDeliveryPointLatLng() {
    final deliveryPointCoordinates = widget.job.deliveryPoint.split(',');
    return LatLng(
      double.parse(deliveryPointCoordinates[0].trim()),
      double.parse(deliveryPointCoordinates[1].trim()),
    );
  }

  AssignmentResponseEntity? _getAssignmentForUser() {
    return widget.job.assignments.firstWhere(
      (e) => e.userId.toString() == widget.staffId,
      orElse: () => AssignmentResponseEntity(
        id: 0,
        userId: 0,
        bookingId: 0,
        status: '',
        staffType: '',
      ),
    );
  }

  bool isStaffComing(String? assignmentStatus) {
    return ((widget.job.status == "COMING" ||
            widget.job.status == "IN_PROGRESS") &&
        (assignmentStatus == "WAITING" ||
            assignmentStatus == "ASSIGNED" ||
            assignmentStatus == "INCOMING"));
  }

  bool isStaffProgress(String? assignmentStatus) {
    return ((widget.job.status == "IN_PROGRESS") &&
        (assignmentStatus == "ARRIVED" || assignmentStatus == "IN_PROGRESS"));
  }

  Future<void> _initNavigation() async {
    if (!mounted) return;
    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.apiKey = APIConstants.apiVietMapKey;
    _navigationOption.mapStyle =
        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=${APIConstants.apiVietMapKey}";
    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  void _buildRoute() async {
    final assignment = _getAssignmentForUser();
    final subStatus = assignment?.status;

    if (_navigationController != null && _staffLocation != null) {
      LatLng waypoint;

      if (isStaffComing(subStatus)) {
        waypoint = _getPickupPointLatLng();
      } else if (isStaffProgress(subStatus)) {
        waypoint = _getDeliveryPointLatLng();
      } else {
        return;
      }

      if (_staffLocation != null) {
        _navigationController?.buildRoute(
          waypoints: [waypoint, _staffLocation!],
          profile: DrivingProfile.cycling,
        ).then((success) {
          if (!success) {
            print('Failed to build route');
          }
        }).catchError((error) {
          print('Error building route: $error');
        });
      }
    }
  }

  void _initStaffTracking() {
    DatabaseReference staffLocationRef = FirebaseDatabase.instance
        .ref()
        .child('tracking_locations/78/DRIVER/61');

    _locationSubscription = staffLocationRef.onValue.listen((event) {
      if (!mounted) return;

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double lat = data['lat'] as double;
        final double long = data['long'] as double;

        setState(() {
          _staffLocation = LatLng(lat, long);
          _updateMapView();
        });
      }
    });
  }

  void _updateMapView() {
    if (_staffLocation == null ||
        !_isMapReady ||
        _navigationController == null) {
      return;
    }

    _navigationController?.animateCamera(
      latLng: _staffLocation!,
      zoom: 15,
      duration: const Duration(milliseconds: 1000),
    );

    _buildRoute();
  }

  // void _addMarker() async {
  //   if (_navigationController != null) {
  //     final assignment = _getAssignmentForUser();
  //     final subStatus = assignment?.status;

  //     LatLng pickupPoint = _getPickupPointLatLng();

  //     LatLng deliveryPoint = _getDeliveryPointLatLng();

  //     List<NavigationMarker> markers = [];

  //     if (isStaffComing(subStatus)) {
  //       markers.add(NavigationMarker(
  //         imagePath: "assets/images/booking/vehicles/truck1.png",
  //         height: 80,
  //         width: 80,
  //         latLng: pickupPoint,
  //       ));
  //     } else if (isStaffProgress(subStatus)) {
  //       markers.add(NavigationMarker(
  //         imagePath: "assets/images/booking/vehicles/truck1.png",
  //         height: 80,
  //         width: 80,
  //         latLng: deliveryPoint,
  //       ));
  //     }

  //     await _navigationController!.addImageMarkers(markers);
  //     print("Markers added successfully: ${markers.length} markers");
  //   }
  // }

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

                  // _addMarker();
                });

                if (_staffLocation != null) {
                  _updateMapView();
                } else {
                  // Khi chưa có staff location, hiển thị route từ điểm pickup đến chính nó
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
              onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
                print('-----------ProgressChange----------');
                print(routeProgressEvent.currentLocation?.bearing);
                print(routeProgressEvent.currentLocation?.altitude);
                print(routeProgressEvent.currentLocation?.accuracy);
                print(routeProgressEvent.currentLocation?.bearing);
                print(routeProgressEvent.currentLocation?.latitude);
                print(routeProgressEvent.currentLocation?.longitude);
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
