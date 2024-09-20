import 'dart:convert';

class SuccessModel {
  final String message;

  SuccessModel({required this.message});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'message': message});

    return result;
  }

  factory SuccessModel.fromMap(Map<String, dynamic> map) {
    return SuccessModel(
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SuccessModel.fromJson(String source) =>
      SuccessModel.fromMap(json.decode(source));
}
