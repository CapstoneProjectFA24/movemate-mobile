import 'dart:convert';

class OTPVerifyRequest {
  final String phone;
  final String otpCode;

  OTPVerifyRequest({
    required this.phone,
    required this.otpCode,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phone': phone});
    result.addAll({'otpCode': otpCode});

    return result;
  }

  factory OTPVerifyRequest.fromMap(Map<String, dynamic> map) {
    return OTPVerifyRequest(
      phone: map['phone'] ?? '',
      otpCode: map['otpCode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPVerifyRequest.fromJson(String source) =>
      OTPVerifyRequest.fromMap(json.decode(source));
}
