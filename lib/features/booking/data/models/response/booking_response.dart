import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_entities.dart';

class BookingResponse {
  final List<BookingEntities> payload;

  BookingResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'payload': payload.map((booking) => booking.toMap()).toList(),
    };
  }

  factory BookingResponse.fromMap(Map<String, dynamic> map) {
    return BookingResponse(
      payload: List<BookingEntities>.from(
        (map['payload'] as List).map(
          (items) => BookingEntities.fromMap(items),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingResponse.fromJson(String source) =>
      BookingResponse.fromMap(json.decode(source));
}
