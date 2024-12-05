import 'dart:convert';

import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';

class IncidentResponse {
  final List<BookingTrackersIncidentEntity> payload;

  IncidentResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'payload': payload.map((x) => x.toMap()).toList(),
    };
  }

  factory IncidentResponse.fromMap(Map<String, dynamic> map) {
    return IncidentResponse(
      payload: List<BookingTrackersIncidentEntity>.from(
          map['payload']?.map((x) => BookingTrackersIncidentEntity.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory IncidentResponse.fromJson(String source) =>
      IncidentResponse.fromMap(json.decode(source));
}
