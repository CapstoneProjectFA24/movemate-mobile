import 'dart:convert';

class OTPVerifyRequest {
  final String idToken;

  OTPVerifyRequest({
    required this.idToken,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'idToken': idToken});

    return result;
  }

  factory OTPVerifyRequest.fromMap(Map<String, dynamic> map) {
    return OTPVerifyRequest(
      idToken: map['idToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPVerifyRequest.fromJson(String source) =>
      OTPVerifyRequest.fromMap(json.decode(source));
}
