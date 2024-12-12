import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/driver_tracking_map_item/location_draggable_sheet.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

@RoutePage()
class TrackingDriverMap extends StatefulWidget {
  final String staffId;
  final OrderEntity job;
  final BookingStatusResult bookingStatus;

  const TrackingDriverMap({
    super.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  static const String apiKey = APIConstants.apiVietMapKey;

  @override
  State<StatefulWidget> createState() => TrackingDriverMapState();
}

class TrackingDriverMapState extends State<TrackingDriverMap> {
  MapNavigationViewController? _navigationController;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  RouteProgressEvent? routeProgressEvent;

  // Staff location tracking
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  LatLng? _staffLocation;
  Timer? _cameraUpdateThrottle;

  // Map state
  bool _isMapReady = false;
  bool _isFollowingDriver = true;

  // Marker handling
  List<NavigationMarker>? _currentMarkers;

  // realtime
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initNavigation();
    _initStaffTracking();
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

  void _initStaffTracking() {
    DatabaseReference staffLocationRef = FirebaseDatabase.instance
        .ref()
        .child('tracking_locations/${widget.job.id}/DRIVER/${widget.staffId}');

    _locationSubscription = staffLocationRef.onValue.listen((event) {
      if (!mounted) return;

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double lat = data['lat'] as double;
        final double long = data['long'] as double;

        setState(() {
          _staffLocation = LatLng(lat, long);
          if (_isFollowingDriver) {
            _throttledCameraUpdate();
          }
          _updateDriverMarker();
        });
      }
    });
  }

  void _throttledCameraUpdate() {
    _cameraUpdateThrottle?.cancel();
    _cameraUpdateThrottle = Timer(const Duration(milliseconds: 100), () {
      _updateMapView();
    });
  }

  void _updateMapView() {
    if (_staffLocation == null ||
        !_isMapReady ||
        _navigationController == null ||
        !_isFollowingDriver) {
      return;
    }
    // double? bearing;

    // if (routeProgressEvent?.currentLocation?.bearing != null) {
    //   bearing = routeProgressEvent!.currentLocation!.bearing!.toDouble();
    // }

    _buildRoute();
  }

  Future<Map<String, dynamic>?> _getBookingData() async {
    try {
      final docSnapshot = await _firestore
          .collection('bookings')
          .doc(widget.job.id.toString())
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print("Error getting Firestore data: $e");
      return null;
    }
  }

  Map<String, bool> _getDriverAssignmentStatus(List assignments) {
    return {
      'isDriverWaiting': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "WAITING"),
      'isDriverAssigned': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "ASSIGNED"),
      'isDriverIncoming': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "INCOMING"),
      'isDriverArrived': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "ARRIVED"),
      'isDriverInprogress': assignments.any(
          (a) => a['StaffType'] == "DRIVER" && a["Status"] == "IN_PROGRESS"),
      'isDriverCompleted': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "COMPLETED"),
      'isDriverFailed': assignments
          .any((a) => a['StaffType'] == "DRIVER" && a["Status"] == "FAILED"),
    };
  }

  Map<String, bool> _getBuildRouteFlags(
      Map<String, bool> driverAssignmentStatus, String fireStoreBookingStatus) {
    bool isDriverStartBuildRoute = false;
    bool isStaffDriverComingToBuildRoute = false;
    bool isDriverInProgressToBuildRoute = false;

    switch (fireStoreBookingStatus) {
      case "COMING":
        isStaffDriverComingToBuildRoute =
            driverAssignmentStatus["isDriverWaiting"]! ||
                driverAssignmentStatus["isDriverAssigned"]! ||
                driverAssignmentStatus["isDriverIncoming"]! ||
                (!driverAssignmentStatus['isDriverInprogress']! &&
                    !driverAssignmentStatus['isDriverCompleted']! &&
                    !driverAssignmentStatus['isDriverFailed']! &&
                    !driverAssignmentStatus['isDriverArrived']!);
        break;
      case "IN_PROGRESS":
        isStaffDriverComingToBuildRoute =
            driverAssignmentStatus["isDriverWaiting"]! ||
                driverAssignmentStatus["isDriverAssigned"]! ||
                driverAssignmentStatus["isDriverIncoming"]! ||
                (!driverAssignmentStatus['isDriverInprogress']! &&
                    !driverAssignmentStatus['isDriverCompleted']! &&
                    !driverAssignmentStatus['isDriverFailed']! &&
                    !driverAssignmentStatus['isDriverArrived']!);

        isDriverInProgressToBuildRoute =
            driverAssignmentStatus["isDriverArrived"]! ||
                driverAssignmentStatus["isDriverInprogress"]!;
        break;
      case "COMPLETED":
        break;
      default:
        break;
    }

    return {
      'isDriverStartBuildRoute': isDriverStartBuildRoute,
      'isStaffDriverComingToBuildRoute': isStaffDriverComingToBuildRoute,
      'isDriverInProgressToBuildRoute': isDriverInProgressToBuildRoute,
    };
  }

  void _buildRoute() async {
    if (_navigationController != null && _staffLocation != null) {
      List<LatLng> waypoints = [];

      final bookingData = await _getBookingData();

      if (bookingData != null &&
          bookingData["Assignments"] != null &&
          bookingData["Status"] != null) {
        final assignments = bookingData["Assignments"] as List;
        final fireStoreBookingStatus = bookingData["Status"] as String;
        final driverAssignmentStatus = _getDriverAssignmentStatus(assignments);
        final buildRouteFlags =
            _getBuildRouteFlags(driverAssignmentStatus, fireStoreBookingStatus);

        print(
            "vinh debug ${buildRouteFlags["isStaffDriverComingToBuildRoute"]!}");
        print(
            "vinh debug 1 ${buildRouteFlags["isDriverInProgressToBuildRoute"]!}");

        if (buildRouteFlags["isStaffDriverComingToBuildRoute"]!) {
          LatLng pickupPoint = _getPickupPointLatLng();
          waypoints = [pickupPoint, _staffLocation!];
        } else if (buildRouteFlags["isDriverInProgressToBuildRoute"]!) {
          LatLng deliveryPoint = _getDeliveryPointLatLng();
          waypoints = [_staffLocation!, deliveryPoint];
        } else {
          return;
        }

        await _navigationController?.buildRoute(
          waypoints: waypoints,
          profile: DrivingProfile.drivingTraffic,
        );
      }
    }
  }

  Future<void> _updateDriverMarker() async {
    if (_navigationController == null || _staffLocation == null) return;

    if (_currentMarkers != null) {
      await _navigationController!.removeMarkers(
        _currentMarkers!.map((m) => m.markerId!).toList(),
      );
    }

    List<NavigationMarker> markers = [];
    // print(
    //     'tuan log in map ${widget.bookingStatus.isStaffDriverComingToBuildRoute} ');
    // Add destination marker
    if (widget.bookingStatus.isStaffDriverComingToBuildRoute) {
      markers.add(NavigationMarker(
        imagePath:
            "https://res.cloudinary.com/dietfw7lr/image/upload/v1731880138/house-fif-1_gif_800_600_uiug9w.gif",
        height: 80,
        width: 80,
        latLng: _getPickupPointLatLng(),
      ));
    } else if (widget.bookingStatus.isDriverInProgressToBuildRoute) {
      markers.add(NavigationMarker(
        imagePath:
            "https://res.cloudinary.com/dietfw7lr/image/upload/v1731880138/house-fif-1_gif_800_600_uiug9w.gif",
        height: 80,
        width: 80,
        latLng: _getDeliveryPointLatLng(),
      ));
    }
// assets/images/booking/vehicles/abf959e9.png
    markers.add(NavigationMarker(
      // imagePath: "assets/images/booking/vehicles/truck1.png",
      imagePath: "assets/images/booking/vehicles/abf959e9.png",
      height: 60,
      width: 60,
      latLng: _staffLocation!,
    ));

    _currentMarkers = await _navigationController!.addImageMarkers(markers);
  }

  LatLng _parseCoordinates(String coordinateString) {
    try {
      final coordinates = coordinateString.split(',');
      return LatLng(
        double.parse(coordinates[0].trim()),
        double.parse(coordinates[1].trim()),
      );
    } catch (e) {
      print('Error parsing coordinates: $e');
      return const LatLng(0, 0);
    }
  }

  LatLng _getPickupPointLatLng() {
    return _parseCoordinates(widget.job.pickupPoint);
  }

  LatLng _getDeliveryPointLatLng() {
    return _parseCoordinates(widget.job.deliveryPoint);
  }

  void _toggleFollowDriver() {
    setState(() {
      _isFollowingDriver = !_isFollowingDriver;
      if (_isFollowingDriver) {
        _updateMapView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Theo dõi tiến trình của tài xế",
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
                _updateMapView();
                _updateDriverMarker();
              });
            },
            onRouteProgressChange: (RouteProgressEvent event) {
              setState(() {
                routeProgressEvent = event;
              });
            },
          ),
          if (_staffLocation == null)
            const Center(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Đang tìm vị trí tài xế...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Map controls
          // Positioned(
          //   right: 16,
          //   bottom: 220,
          //   child: Column(
          //     children: [
          //       FloatingActionButton(
          //         heroTag: "chat",
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const ChatScreen()),
          //           );
          //         },
          //         backgroundColor: Colors.orange,
          //         child: const Icon(Icons.chat),
          //       ),
          //       const SizedBox(height: 4),
          //     ],
          //   ),
          // ),
          // Trip info card
          if (routeProgressEvent != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thời gian còn lại: ${(routeProgressEvent!.durationRemaining! / 60).toStringAsFixed(0)} phút',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Khoảng cách: ${(routeProgressEvent!.distanceRemaining! / 1000).toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // if (routeProgressEvent != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.7, // Chiều cao giới hạn
              child:

                  // TrackingMapBottomSheet(
                  //   job: widget.job,
                  // ),
                  DeliveryDetailsBottomSheet(
                stadffId: int.parse(widget.staffId),
                job: widget.job,
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
    _cameraUpdateThrottle?.cancel();
    if (_navigationController != null) {
      _navigationController!.onDispose();
    }
    super.dispose();
  }
}
