import 'dart:convert';

class   RegisterTokenRequest {
  final String fcmToken;

  RegisterTokenRequest({required this.fcmToken});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'fcmToken': fcmToken});

    return result;
  }

  factory RegisterTokenRequest.fromMap(Map<String, dynamic> map) {
    return RegisterTokenRequest(
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterTokenRequest.fromJson(String source) =>
      RegisterTokenRequest.fromMap(json.decode(source));
}
