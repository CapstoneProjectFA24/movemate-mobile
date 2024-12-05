import 'dart:convert';

class ChangeBookingAtRequest {
  final String bookingAt;

  ChangeBookingAtRequest({
    required this.bookingAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'bookingAt': bookingAt});

    return result;
  }

  factory ChangeBookingAtRequest.fromMap(Map<String, dynamic> map) {
    return ChangeBookingAtRequest(
      bookingAt: map['bookingAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeBookingAtRequest.fromJson(String source) =>
      ChangeBookingAtRequest.fromMap(json.decode(source));
}
