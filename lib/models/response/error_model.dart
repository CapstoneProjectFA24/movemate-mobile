// import 'dart:convert';
// import 'error_detail_model.dart';

// class ErrorModel {
//   final int statusCode;
//   final List<ErrorDetailModel> message;

//   ErrorModel({
//     required this.statusCode,
//     required this.message,
//   });

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};

//     result.addAll({'StatusCode': statusCode});
//     result.addAll({'Message': message.map((x) => x.toMap()).toList()});

//     return result;
//   }

//   factory ErrorModel.fromMap(Map<String, dynamic> map) {
//     return ErrorModel(
//       statusCode: map['StatusCode']?.toInt() ?? 0,
//       message: List<ErrorDetailModel>.from(map['message'] != null
//           ? map['message'].map((x) => ErrorDetailModel.fromMap(x))
//           : map['Message'].map((x) => ErrorDetailModel.fromMap(x))),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ErrorModel.fromJson(String source) =>
//       ErrorModel.fromMap(json.decode(source));
// }


import 'dart:convert';

class ErrorModel {
  final int statusCode;
  final String message;

  ErrorModel({
    required this.statusCode,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      statusCode: map['statusCode']?.toInt() ?? 0,
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) => ErrorModel.fromMap(json.decode(source));

  @override
  String toString() => 'Error: $message (Status Code: $statusCode)';
}