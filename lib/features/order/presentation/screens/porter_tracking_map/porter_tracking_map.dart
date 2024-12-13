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
class PorterTrackingMap extends StatefulWidget {
  final String staffId;
  final OrderEntity job;
  final BookingStatusResult bookingStatus;

  const PorterTrackingMap({
    super.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  static const String apiKey = APIConstants.apiVietMapKey;

  @override
  State<StatefulWidget> createState() => PorterTrackingMapState();
}

class PorterTrackingMapState extends State<PorterTrackingMap> {
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

  bool isOpenHeaderTrackingStatus = false;

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
        .child('tracking_locations/${widget.job.id}/PORTER/${widget.staffId}');

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
          _updatePorterMarker();
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

  Map<String, bool> _getPorterAssignmentStatus(List assignments) {
    if (widget.staffId.isEmpty) {
      return {
        'isPorterWaiting': false,
        'isPorterAssigned': false,
        'isPorterIncoming': false,
        'isPorterArrived': false,
        'isPorterInprogress': false,
        'isPorterPacking': false,
        'isPorterOngoing': false,
        'isPorterDelivered': false,
        'isPorterUnloaded': false,
        'isPorterCompleted': false,
      };
    }

    final staffAssignment = assignments.firstWhere(
      (a) {
        return a['StaffType'] == 'PORTER' &&
            a['UserId'].toString() == widget.staffId.toString();
      },
      orElse: () => null,
    );

    if (staffAssignment == null) {
      return {
        'isPorterWaiting': false,
        'isPorterAssigned': false,
        'isPorterIncoming': false,
        'isPorterArrived': false,
        'isPorterInprogress': false,
        'isPorterPacking': false,
        'isPorterOngoing': false,
        'isPorterDelivered': false,
        'isPorterUnloaded': false,
        'isPorterCompleted': false,
      };
    }
    return {
      'isPorterWaiting': staffAssignment["Status"] == "WAITING",
      'isPorterAssigned': staffAssignment["Status"] == "ASSIGNED",
      'isPorterIncoming': staffAssignment["Status"] == "INCOMING",
      'isPorterArrived': staffAssignment["Status"] == "ARRIVED",
      'isPorterInprogress': staffAssignment["Status"] == "IN_PROGRESS",
      'isPorterPacking': staffAssignment["Status"] == "PACKING",
      'isPorterOngoing': staffAssignment["Status"] == "ONGOING",
      'isPorterDelivered': staffAssignment["Status"] == "DELIVERED",
      'isPorterUnloaded': staffAssignment["Status"] == "UNLOADED",
      'isPorterCompleted': staffAssignment["Status"] == "COMPLETED",
      'isPorterFailed': staffAssignment["Status"] == "FAILED",
    };

    // return {
    //   'isPorterWaiting': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "WAITING"),
    //   'isPorterAssigned': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "ASSIGNED"),
    //   'isPorterIncoming': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "INCOMING"),
    //   'isPorterArrived': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "ARRIVED"),
    //   'isPorterInprogress': assignments.any(
    //       (a) => a['StaffType'] == "PORTER" && a["Status"] == "IN_PROGRESS"),
    //   'isPorterPacking': assignments
    //       .any((a) => a["StaffType"] == "PORTER" && a["Status"] == "PACKING"),
    //   'isPorterOngoing': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "ONGOING"),
    //   'isPorterDelivered': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "DELIVERED"),
    //   'isPorterUnloaded': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "UNLOADED"),
    //   'isPorterCompleted': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "COMPLETED"),
    //   'isPorterFailed': assignments
    //       .any((a) => a['StaffType'] == "PORTER" && a["Status"] == "FAILED"),
    // };
  }

  Map<String, bool> _getBuildRouteFlags(
      Map<String, bool> porterAssignmentStatus, String fireStoreBookingStatus) {
    bool isPorterStartBuildRoute = false;
    bool isPorterAtDeliveryPointBuildRoute = false;
    bool isPorterEndDeliveryPointBuildRoute = false;

    switch (fireStoreBookingStatus) {
      case "COMING":
        isPorterStartBuildRoute = porterAssignmentStatus['isPorterWaiting']! ||
            porterAssignmentStatus['isPorterAssigned']! ||
            porterAssignmentStatus['isPorterIncoming']! ||
            (!porterAssignmentStatus['isPorterInprogress']! &&
                !porterAssignmentStatus['isPorterCompleted']! &&
                !porterAssignmentStatus['isPorterFailed']!);

        break;
      case "IN_PROGRESS":
        isPorterStartBuildRoute = porterAssignmentStatus['isPorterWaiting']! ||
            porterAssignmentStatus['isPorterAssigned']! ||
            porterAssignmentStatus['isPorterIncoming']! ||
            (!porterAssignmentStatus['isPorterInprogress']! &&
                !porterAssignmentStatus['isPorterArrived']! &&
                !porterAssignmentStatus['isPorterPacking']! &&
                !porterAssignmentStatus['isPorterDelivered']! &&
                !porterAssignmentStatus['isPorterOngoing']! &&
                !porterAssignmentStatus['isPorterCompleted']! &&
                !porterAssignmentStatus['isPorterFailed']!);
        isPorterAtDeliveryPointBuildRoute =
            (porterAssignmentStatus['isPorterArrived']! ||
                    porterAssignmentStatus['isPorterInprogress']! ||
                    porterAssignmentStatus["isPorterPacking"]! ||
                    porterAssignmentStatus["isPorterOngoing"]!) &&
                (!porterAssignmentStatus["isPorterUnloaded"]! ||
                    !porterAssignmentStatus['isPorterDelivered']! ||
                    !porterAssignmentStatus['isPorterCompleted']! ||
                    !porterAssignmentStatus['isPorterIncoming']! ||
                    !porterAssignmentStatus['isPorterAssigned']! ||
                    !porterAssignmentStatus['isPorterUnloaded']! ||
                    !porterAssignmentStatus['isPorterFailed']!);
        isPorterEndDeliveryPointBuildRoute =
            (porterAssignmentStatus['isPorterCompleted']! ||
                    porterAssignmentStatus["isPorterDelivered"]! ||
                    porterAssignmentStatus["isPorterUnloaded"]!) &&
                !porterAssignmentStatus['isPorterFailed']!;

        break;
      case "COMPLETED":
        isPorterEndDeliveryPointBuildRoute =
            (porterAssignmentStatus['isPorterCompleted']! ||
                    porterAssignmentStatus["isPorterDelivered"]! ||
                    porterAssignmentStatus["isPorterUnloaded"]!) &&
                !porterAssignmentStatus['isPorterFailed']!;
        setState(() {
          // canDriverConfirmIncomingFlag = false;
          // canDriverStartMovingFlag = false;
        });
        break;
      default:
        break;
    }

    return {
      'isPorterStartBuildRoute': isPorterStartBuildRoute,
      'isPorterAtDeliveryPointBuildRoute': isPorterAtDeliveryPointBuildRoute,
      'isPorterEndDeliveryPointBuildRoute': isPorterEndDeliveryPointBuildRoute,
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

        final porterAssignmentStatus = _getPorterAssignmentStatus(assignments);
        final buildRouteFlags =
            _getBuildRouteFlags(porterAssignmentStatus, fireStoreBookingStatus);

        print("vinh debug ${buildRouteFlags["isPorterStartBuildRoute"]!}");
        print(
            "vinh debug 1 ${buildRouteFlags["isPorterAtDeliveryPointBuildRoute"]!}");

        if (buildRouteFlags["isPorterStartBuildRoute"]!) {
          LatLng pickupPoint = _getPickupPointLatLng();
          waypoints = [pickupPoint, _staffLocation!];
        } else if (buildRouteFlags["isPorterAtDeliveryPointBuildRoute"]!) {
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

  Future<void> _updatePorterMarker() async {
    if (_navigationController == null || _staffLocation == null) return;

    final bookingData = await _getBookingData();
    if (bookingData != null &&
        bookingData["Assignments"] != null &&
        bookingData["Status"] != null) {
      LatLng pickupPoint = _getPickupPointLatLng();
      LatLng deliveryPoint = _getDeliveryPointLatLng();
      // logic
      final assignments = bookingData["Assignments"] as List;
      final fireStoreBookingStatus = bookingData["Status"] as String;

      final porterAssignmentStatus = _getPorterAssignmentStatus(assignments);

      final buildRouteFlags =
          _getBuildRouteFlags(porterAssignmentStatus, fireStoreBookingStatus);

      if (_currentMarkers != null) {
        await _navigationController!.removeMarkers(
          _currentMarkers!.map((m) => m.markerId!).toList(),
        );
      }

      List<NavigationMarker> markers = [];
      // print(
      //     'tuan log in map ${widget.bookingStatus.isStaffDriverComingToBuildRoute} ');
      // Add destination marker
      if (buildRouteFlags["isPorterStartBuildRoute"]!) {
        markers.add(NavigationMarker(
          imagePath: "assets/icons/icons8-home-80.png",
          height: 80,
          width: 80,
          latLng: pickupPoint,
        ));
      } else if (buildRouteFlags["isPorterAtDeliveryPointBuildRoute"]!) {
        markers.add(NavigationMarker(
          imagePath: "assets/icons/icons8-home-80.png",
          height: 80,
          width: 80,
          latLng: deliveryPoint,
        ));
      }
      markers.add(NavigationMarker(
        imagePath: "assets/images/booking/vehicles/truck1.png",
        height: 60,
        width: 60,
        latLng: _staffLocation!,
      ));

      _currentMarkers = await _navigationController!.addImageMarkers(markers);
      if (_staffLocation != null) {
        await _navigationController!
            .removeAllMarkers(); // Xóa tất cả markers cũ
      }
      _currentMarkers = await _navigationController!.addImageMarkers(markers);
    }
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
        title: "Theo dõi tiến trình của bốc vác",
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
                _updatePorterMarker();
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
                color: AssetsConstants.primaryLight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Đang tìm vị trí bốc vác...',
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
