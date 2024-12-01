import 'dart:convert';


class CancelBooking {
  final int id;
  final String cancelReason;

  CancelBooking({
    required this.id,
    required this.cancelReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cancelReason': cancelReason,
    };
  }

  factory CancelBooking.fromMap(Map<String, dynamic> map) {
    return CancelBooking(
      cancelReason: (map['cancelReason'] as String),
      id: (map['id']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelBooking.fromJson(String source) =>
      CancelBooking.fromMap(json.decode(source));
}
