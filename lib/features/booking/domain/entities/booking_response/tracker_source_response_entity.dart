// lib/features/booking/domain/entities/tracker_source_response_entity.dart

import 'dart:convert';

class TrackerSourceResponseEntity {
  final int id;
  final int bookingTrackerId;
  final String resourceUrl;
  final String resourceCode;
  final String type;

  TrackerSourceResponseEntity({
    required this.id,
    required this.bookingTrackerId,
    required this.resourceUrl,
    required this.resourceCode,
    required this.type,
  });

  factory TrackerSourceResponseEntity.fromMap(Map<String, dynamic> json) {
    return TrackerSourceResponseEntity(
      id: json['id'] ?? 0,
      bookingTrackerId: json['bookingTrackerId'] ?? 0,
      resourceUrl: json['resourceUrl'] ?? '',
      resourceCode: json['resourceCode'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingTrackerId': bookingTrackerId,
      'resourceUrl': resourceUrl,
      'resourceCode': resourceCode,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());

  factory TrackerSourceResponseEntity.fromJson(String source) =>
      TrackerSourceResponseEntity.fromMap(json.decode(source));
}
