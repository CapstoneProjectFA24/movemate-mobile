import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfoCard extends StatelessWidget {
  final Position position;

  const LocationInfoCard({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    print("vinh test gps $position");
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vĩ độ: ${position.latitude.toStringAsFixed(6)}'),
          Text('Kinh độ: ${position.longitude.toStringAsFixed(6)}'),
          Text('Độ cao: ${position.altitude.toStringAsFixed(1)}m'),
          Text('Tốc độ: ${position.speed.toStringAsFixed(1)}m/s'),
        ],
      ),
    );
  }
}

class MapActionButtons extends StatelessWidget {
  final VoidCallback onMyLocationPressed;
  final VoidCallback? onFocusAllMarkersPressed;
  final VoidCallback? onDrawRoutePressed; // Thêm callback cho vẽ route
  final bool showFocusAllMarkers;
  final bool showDrawRoute; // Thêm flag để hiển thị nút vẽ route

  const MapActionButtons({
    super.key,
    required this.onMyLocationPressed,
    this.onFocusAllMarkersPressed,
    this.onDrawRoutePressed,
    this.showFocusAllMarkers = false,
    this.showDrawRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: onMyLocationPressed,
          child: const Icon(Icons.my_location),
        ),
        if (showFocusAllMarkers && onFocusAllMarkersPressed != null) ...[
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            onPressed: onFocusAllMarkersPressed,
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
        if (showDrawRoute && onDrawRoutePressed != null) ...[
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            onPressed: onDrawRoutePressed,
            child: const Icon(Icons.route),
          ),
        ],
      ],
    );
  }
}
