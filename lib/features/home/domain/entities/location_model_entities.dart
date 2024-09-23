// location_model.dart

class LocationModel {
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final String distance;

  LocationModel({
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      label: json['label'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
    };
  }
}
