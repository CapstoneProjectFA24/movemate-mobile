import 'dart:convert';

class SuccessModel {
  final int statusCode; 
  final String message;

  SuccessModel({
    required this.statusCode,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode, 
      'message': message,
    };
  }

  factory SuccessModel.fromMap(Map<String, dynamic> map) {
    return SuccessModel(
      statusCode: map['statusCode']?.toInt() ?? 0,
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SuccessModel.fromJson(String source) =>
      SuccessModel.fromMap(json.decode(source));

  @override
  String toString() => 'Success: $message (Status Code: $statusCode)'; 
}
