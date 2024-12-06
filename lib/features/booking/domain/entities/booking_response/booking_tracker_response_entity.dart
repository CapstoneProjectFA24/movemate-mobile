// lib/features/booking/domain/entities/booking_tracker_response_entity.dart

import 'dart:convert';
import 'tracker_source_response_entity.dart';

class BookingTrackerResponseEntity {
  final int id;
  final int bookingId;
  final String time;
  final String type;
  final String? location;
  final String? point;
  final String? description;
  final String? status;
  final bool? isInsurance;
  final List<TrackerSourceResponseEntity> trackerSources;

  BookingTrackerResponseEntity({
    required this.id,
    required this.bookingId,
    required this.time,
    required this.type,
    this.location,
    this.point,
    this.description,
    this.status,
    this.isInsurance,
    required this.trackerSources,
  });

  factory BookingTrackerResponseEntity.fromMap(Map<String, dynamic> json) {
    return BookingTrackerResponseEntity(
      id: json['id'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      location: json['location'],
      point: json['point'],
      description: json['description'],
      status: json['status'],
      isInsurance: json['isInsurance'] ?? false,
      trackerSources: (json['trackerSources'] as List<dynamic>?)
              ?.map((e) => TrackerSourceResponseEntity.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'time': time,
      'type': type,
      'location': location,
      'point': point,
      'description': description,
      'status': status,
      'isInsurance': isInsurance,
      'trackerSources': trackerSources.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory BookingTrackerResponseEntity.fromJson(String source) =>
      BookingTrackerResponseEntity.fromMap(json.decode(source));
}
