import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/driver_tracking_map_item/chat_screen.dart';
import 'package:movemate/features/order/presentation/widgets/reviewer_tracking_map_item/reviewer_status_bottom_sheet.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

@RoutePage()
class ReviewerTrackingMap extends StatefulWidget {
  final String staffId;
  final OrderEntity job;
  final BookingStatusResult bookingStatus;

  const ReviewerTrackingMap({
    super.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  static const String apiKey = APIConstants.apiVietMapKey;
  @override
  State<StatefulWidget> createState() => ReviewerTrackingMapState();
}

class ReviewerTrackingMapState extends State<ReviewerTrackingMap> {
  MapNavigationViewController? _navigationController;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  RouteProgressEvent? routeProgressEvent;
  // Staff location tracking
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  LatLng? _staffLocation;

  // Map state
  bool _isMapReady = false;
  bool ispauleModal = false;
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
    if (_navigationController != null && _staffLocation != null) {
      LatLng pickupPoint = _getPickupPointLatLng();
      if (_staffLocation?.latitude != pickupPoint.latitude ||
          _staffLocation?.longitude != pickupPoint.longitude) {
        await _navigationController?.buildRoute(waypoints: [
          // const LatLng(10.751169, 106.607249),
          // const LatLng(10.775458, 106.601052)
          _staffLocation!, pickupPoint
        ], profile: DrivingProfile.drivingTraffic);

        _addMarker();
      } else {
        ispauleModal = true;
        if ((_staffLocation?.latitude == pickupPoint.latitude ||
                _staffLocation?.longitude == pickupPoint) &&
            ispauleModal) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              ispauleModal = false;
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
                              'Người đánh giá đã tới',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Xác nhận với người đánh giá',
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
      }
    }
  }

  void _initStaffTracking() {
    DatabaseReference staffLocationRef = FirebaseDatabase.instance.ref().child(
        'tracking_locations/${widget.job.id}/REVIEWER/${widget.staffId}');

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

    _buildRoute();
  }

  void _addMarker() async {
    if (_navigationController != null) {
      LatLng pickupPoint = _getPickupPointLatLng();

      List<NavigationMarker> markers = [
        NavigationMarker(
          // imagePath: "assets/images/booking/vehicles/truck1.png",
          imagePath: "assets/icons/icons8-home-80.png",
          height: 70,
          width: 70,
          latLng: pickupPoint,
        ),
        // Tạo marker cho điểm đích (pickup point)
        NavigationMarker(
          imagePath:
              "assets/images/booking/vehicles/truck1.png", // Icon cho đích
          height: 80,
          width: 80,
          latLng: _staffLocation!,
        ),
      ];

      await _navigationController!.addImageMarkers(markers);

      print("Markers added successfully: ${markers.length} markers");

      if (_staffLocation != pickupPoint) {
        await _navigationController!
            .removeAllMarkers(); // Xóa tất cả markers cũ
        print("Old markers cleared.");
      }

      await _navigationController!.addImageMarkers(markers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Theo dõi tiến trình của người đánh giá",
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
                  _addMarker();
                });
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
              child: ReviewerStatusBottomSheet(
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
