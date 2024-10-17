import 'dart:convert';

class PaymentResponse {
  final String payload;

  PaymentResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload});

    return result;
  }

  factory PaymentResponse.fromMap(Map<String, dynamic> map) {
    return PaymentResponse(
      payload: map['payload'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentResponse.fromJson(String source) =>
      PaymentResponse.fromMap(json.decode(source));
}
