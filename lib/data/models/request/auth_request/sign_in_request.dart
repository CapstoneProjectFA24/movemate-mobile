import 'dart:convert';

class SignInRequest {
  final String? email;
  final String? phone;
  final String password;

  SignInRequest({
     this.email,
     this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'password': password});
    result.addAll({'email': email});
    result.addAll({'phone': phone});

    return result;
  }

  factory SignInRequest.fromMap(Map<String, dynamic> map) {
    return SignInRequest(
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SignInRequest.fromJson(String source) =>
      SignInRequest.fromMap(json.decode(source));
}
