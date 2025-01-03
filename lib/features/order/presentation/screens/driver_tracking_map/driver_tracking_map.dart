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

  //check fail flag
  bool checkFailFlag = false;

  @override
  void initState() {
    super.initState();

    _initNavigation();
    _initStaffTracking();
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
    // print("check log id assgfn 1 ${widget.staffId}");
    // Kiểm tra xem staffId có giá trị và không rỗng không
    if (widget.staffId.isEmpty) {
      // print("Staff ID is null or empty");
      return {
        'isDriverWaiting': false,
        'isDriverAssigned': false,
        'isDriverIncoming': false,
        'isDriverArrived': false,
        'isDriverInprogress': false,
        'isDriverCompleted': false,
        'isDriverFailed': false,
      };
    }

    // print("check log id assgfn 2 ${widget.staffId}");

    final staffAssignment = assignments.firstWhere(
      (a) {
        // print("check log Checking assignment: $a");
        // print("check log StaffType: ${a['StaffType']}");
        // print("check log UserId: ${a['UserId']}");
        // print("check log Comparing with staffId: ${widget.staffId}");
        return a['StaffType'] == 'DRIVER' &&
            a['UserId'].toString() == widget.staffId.toString();
      },
      orElse: () => null,
    );

    print("check log assignment 3 $assignments");
    print("check log assignment 4 $staffAssignment");

    if (staffAssignment == null) {
      return {
        'isDriverWaiting': false,
        'isDriverAssigned': false,
        'isDriverIncoming': false,
        'isDriverArrived': false,
        'isDriverInprogress': false,
        'isDriverCompleted': false,
        'isDriverFailed': false,
      };
    }

    return {
      'isDriverWaiting': staffAssignment['Status'] == 'WAITING',
      'isDriverAssigned': staffAssignment['Status'] == 'ASSIGNED',
      'isDriverIncoming': staffAssignment['Status'] == 'INCOMING',
      'isDriverArrived': staffAssignment['Status'] == 'ARRIVED',
      'isDriverInprogress': staffAssignment['Status'] == 'IN_PROGRESS',
      'isDriverCompleted': staffAssignment['Status'] == 'COMPLETED',
      'isDriverFailed': staffAssignment['Status'] == 'FAILED',
    };
  }

  Map<String, bool> _getBuildRouteFlags(
      Map<String, bool> driverAssignmentStatus, String fireStoreBookingStatus) {
    bool isDriverStartBuildRoute = false;
    bool isStaffDriverComingToBuildRoute = false;
    bool isDriverInProgressToBuildRoute = false;
    bool isDriverFinish = false;

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
        isDriverFinish = driverAssignmentStatus["isDriverCompleted"]!;

        isDriverInProgressToBuildRoute =
            driverAssignmentStatus["isDriverArrived"]! ||
                driverAssignmentStatus["isDriverInprogress"]!;
        break;
      case "COMPLETED":
        isDriverFinish = driverAssignmentStatus["isDriverCompleted"]!;
        break;
      default:
        break;
    }

    return {
      'isDriverStartBuildRoute': isDriverStartBuildRoute,
      'isStaffDriverComingToBuildRoute': isStaffDriverComingToBuildRoute,
      'isDriverInProgressToBuildRoute': isDriverInProgressToBuildRoute,
      'isDriverFinish': isDriverFinish,
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

        if (buildRouteFlags["isStaffDriverComingToBuildRoute"]!) {
          LatLng pickupPoint = _getPickupPointLatLng();

          if (_staffLocation?.latitude != pickupPoint.latitude ||
              _staffLocation?.longitude != pickupPoint.longitude) {
            waypoints = [pickupPoint, _staffLocation!];
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFFFF8F0)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              // colors: [Color(0xFFFF9900), Color(0xFFFFB446)],
                              colors: [
                                AssetsConstants.mainColor,
                                AssetsConstants.mainColor
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF9900).withOpacity(0.7),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 600),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AssetsConstants.mainColor,
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.rate_review_rounded,
                                    size: 32,
                                    color: AssetsConstants.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Column(
                            children: [
                              const Text(
                                'Nhân viên đã tới',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Hãy quay lại màn hình chính để kiểm tra các trạng thái của đơn',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        // Buttons
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: Row(
                            children: [
                              // "Đánh giá ngay" button
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AssetsConstants.mainColor,
                                        AssetsConstants.mainColor
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF9900)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else if (buildRouteFlags["isDriverInProgressToBuildRoute"]!) {
          LatLng deliveryPoint = _getDeliveryPointLatLng();
          if (_staffLocation?.latitude != deliveryPoint.latitude ||
              _staffLocation?.longitude != deliveryPoint.longitude) {
            waypoints = [_staffLocation!, deliveryPoint];
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFFFF8F0)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              // colors: [Color(0xFFFF9900), Color(0xFFFFB446)],
                              colors: [
                                AssetsConstants.mainColor,
                                AssetsConstants.mainColor
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF9900).withOpacity(0.7),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 600),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AssetsConstants.mainColor,
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.rate_review_rounded,
                                    size: 32,
                                    color: AssetsConstants.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Column(
                            children: [
                              const Text(
                                'Nhân viên đã tới',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Hãy quay lại màn hình chính để kiểm tra các trạng thái của đơn',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        // Buttons
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: Row(
                            children: [
                              // "Đánh giá ngay" button
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AssetsConstants.mainColor,
                                        AssetsConstants.mainColor
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF9900)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else if (buildRouteFlags["isDriverFinish"]!) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFFFF8F0)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            // colors: [Color(0xFFFF9900), Color(0xFFFFB446)],
                            colors: [
                              AssetsConstants.mainColor,
                              AssetsConstants.mainColor
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9900).withOpacity(0.7),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 600),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, double value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AssetsConstants.mainColor,
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.rate_review_rounded,
                                  size: 32,
                                  color: AssetsConstants.mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Column(
                          children: [
                            const Text(
                              'Nhân viên đã hoàn thành công việc',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hãy quay lại màn hình chính để kiểm tra các trạng thái của đơn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),

                      // Buttons
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Row(
                          children: [
                            // "Đánh giá ngay" button
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AssetsConstants.mainColor,
                                      AssetsConstants.mainColor
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9900)
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Xác nhận',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return;
        }

        await _navigationController?.buildRoute(
          waypoints: waypoints,
          profile: DrivingProfile.drivingTraffic,
        );
        _updateDriverMarker();
      }
    }
  }

  Future<void> _updateDriverMarker() async {
    final bookingData = await _getBookingData();
    final assignments = bookingData!["Assignments"] as List;

    final fireStoreBookingStatus = bookingData["Status"] as String;
    final driverAssignmentStatus = _getDriverAssignmentStatus(assignments);
    final buildRouteFlags =
        _getBuildRouteFlags(driverAssignmentStatus, fireStoreBookingStatus);

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
    if (_navigationController != null && _staffLocation != null) {
      LatLng pickupPoint = _getPickupPointLatLng();
      LatLng deliveryPoint = _getDeliveryPointLatLng();
      // print(
      //     'check status  isStaffDriverComingToBuildRoute 1 ${buildRouteFlags["isStaffDriverComingToBuildRoute"]!}');
      // print(
      //     'check status  isDriverInProgressToBuildRoute 2 ${buildRouteFlags["isDriverInProgressToBuildRoute"]!}');

      if (buildRouteFlags["isStaffDriverComingToBuildRoute"]!) {
        markers.add(NavigationMarker(
          imagePath: "assets/icons/icons8-home-80.png",
          height: 80,
          width: 80,
          latLng: pickupPoint,
        ));
        markers.add(NavigationMarker(
          imagePath: "assets/images/booking/vehicles/truck1.png",
          height: 70,
          width: 70,
          latLng: _staffLocation!,
        ));
      } else if (buildRouteFlags["isDriverInProgressToBuildRoute"]!) {
        markers.add(NavigationMarker(
          imagePath: "assets/icons/icons8-home-80.png",
          height: 80,
          width: 80,
          latLng: deliveryPoint,
        ));

        markers.add(NavigationMarker(
          imagePath: "assets/images/booking/vehicles/truck1.png",
          height: 70,
          width: 70,
          latLng: _staffLocation!,
        ));
      }
// assets/images/booking/vehicles/abf959e9.png

      await _navigationController!.addImageMarkers(markers);
      if (_staffLocation != null) {
        await _navigationController!
            .removeAllMarkers(); // Xóa tất cả markers cũ
      }
      await _navigationController!.addImageMarkers(markers);
    }
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
                color: AssetsConstants.primaryLight,
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
