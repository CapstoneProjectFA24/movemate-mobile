import 'dart:convert';

class IncidentQueries {
  final int? bookingId;
  final int? userId;

  IncidentQueries({
    this.userId,
    this.bookingId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userId != null) {
      result['UserId'] = userId;
    }

    if (bookingId != null) {
      result['BookingId'] = bookingId;
    }

    return result;
  }

  factory IncidentQueries.fromMap(Map<String, dynamic> map) {
    return IncidentQueries(
      userId: map['UserId'] ?? 0,
      bookingId: map['BookingId'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncidentQueries.fromJson(String source) =>
      IncidentQueries.fromMap(json.decode(source));
}
