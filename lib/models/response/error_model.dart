import 'dart:convert';

class ErrorModel {
  final int statusCode;
  final String message;
   final List<String> errors;

  ErrorModel({
    required this.statusCode,
    required this.message,
     required this.errors,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
      'errors': errors,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      statusCode: map['statusCode']?.toInt() ?? 0,
      message: map['message'] ?? '',
       errors: List<String>.from(map['errors'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) => ErrorModel.fromMap(json.decode(source));

  @override
  String toString() => 'Error: $message (Status Code: $statusCode)';
}