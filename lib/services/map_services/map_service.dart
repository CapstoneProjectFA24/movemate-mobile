// lib/services/map_service.dart

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:http/http.dart' as http;

class MapService {
  static void focusOnLocation(VietmapController controller, LatLng location,
      {double zoom = 15}) {
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(location, zoom),
    );
  }

  static const String _routingBaseUrl = 'https://maps.vietmap.vn/api/route';

  static void focusOnAllMarkers(
    VietmapController controller,
    List<LatLng> locations, {
    double padding = 0.1,
    EdgeInsets cameraPadding = const EdgeInsets.all(50),
  }) {
    if (locations.isEmpty) return;

    if (locations.length == 1) {
      focusOnLocation(controller, locations.first);
      return;
    }

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var location in locations) {
      minLat = math.min(minLat, location.latitude);
      maxLat = math.max(maxLat, location.latitude);
      minLng = math.min(minLng, location.longitude);
      maxLng = math.max(maxLng, location.longitude);
    }

    final latPadding = (maxLat - minLat) * padding;
    final lngPadding = (maxLng - minLng) * padding;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - latPadding, minLng - lngPadding),
          northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
        ),
        left: cameraPadding.left,
        top: cameraPadding.top,
        right: cameraPadding.right,
        bottom: cameraPadding.bottom,
      ),
    );
  }

  static Future<List<LatLng>> getRouteCoordinates({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final queryParams = {
        'api-version': '1.1',
        'apikey': APIConstants.apiVietMapKey,
        'point': [
          '${origin.latitude},${origin.longitude}',
          '${destination.latitude},${destination.longitude}'
        ].join('&point='),
        'vehicle': 'car',
        'points_encoded': 'false'
      };

      final uri =
          Uri.parse(_routingBaseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'][0]['points']['coordinates'] as List;

        return paths.map((point) {
          final coords = point as List;
          return LatLng(coords[1], coords[0]); // Vietmap trả về [lng, lat]
        }).toList();
      }

      throw Exception('Failed to get route: ${response.statusCode}');
    } catch (e) {
      throw Exception('Route calculation failed: $e');
    }
  }

  static Future<Line?> drawRoute({
    required VietmapController controller,
    required LatLng origin,
    required LatLng destination,
    Color routeColor = Colors.orange,
    double routeWidth = 4.0,
  }) async {
    try {
      // Xóa route cũ nếu có
      await clearRoute(controller);

      // Lấy tọa độ cho route
      final coordinates = await getRouteCoordinates(
        origin: origin,
        destination: destination,
      );

      // Tạo line options
      final lineOptions = PolylineOptions(
        geometry: coordinates,
        polylineColor: routeColor,
        polylineWidth: routeWidth,
        polylineOpacity: 0.8,
      );

      // Vẽ route mới
      return await controller.addPolyline(lineOptions);
    } catch (e) {
      debugPrint('Error drawing route: $e');
      return null;
    }
  }

  static Future<void> clearRoute(VietmapController controller) async {
    try {
      // Lấy danh sách tất cả các line
      // final lines = await controller.getLines();

      // Xóa từng line
      // for (var line in lines) {
      await controller.clearLines();
      // }
    } catch (e) {
      debugPrint('Error clearing routes: $e');
    }
  }

  static double calculateDistance(LatLng point1, LatLng point2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = math.cos;
    var a = 0.5 -
        c((point2.latitude - point1.latitude) * p) / 2 +
        c(point1.latitude * p) *
            c(point2.latitude * p) *
            (1 - c((point2.longitude - point1.longitude) * p)) /
            2;

    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }
}
