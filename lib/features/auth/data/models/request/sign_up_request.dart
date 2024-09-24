import 'dart:convert';

class SignUpRequest {
  final String email;
  final String name;
  final String phone;
  final String password;

  SignUpRequest({
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'phone': phone});
    result.addAll({'name': name});


    return result;
  }

  factory SignUpRequest.fromMap(Map<String, dynamic> map) {
    return SignUpRequest(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
    @override
  String toString() {
    return 'SignUpRequest(email: $email, name: $name, phone: $phone, password: $password)';
  }

  factory SignUpRequest.fromJson(String source) =>
      SignUpRequest.fromMap(json.decode(source));
}