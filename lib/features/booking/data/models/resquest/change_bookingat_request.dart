import 'dart:convert';


class ChangeBookingatRequest {
  final String bookingAt;

  ChangeBookingatRequest({
    required this.bookingAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingAt': bookingAt,
    };
  }

  factory ChangeBookingatRequest.fromMap(Map<String, dynamic> map) {
    return ChangeBookingatRequest(
      bookingAt: (map['bookingAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeBookingatRequest.fromJson(String source) =>
      ChangeBookingatRequest.fromMap(json.decode(source));
}
