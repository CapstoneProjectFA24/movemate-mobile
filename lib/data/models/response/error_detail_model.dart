import 'dart:convert';

class ErrorDetailModel {
  final String fieldNameError;
  final List<String> descriptionError;

  ErrorDetailModel({
    required this.fieldNameError,
    required this.descriptionError,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'FieldNameError': fieldNameError});
    result.addAll({'DescriptionError': descriptionError});

    return result;
  }

  factory ErrorDetailModel.fromMap(Map<String, dynamic> map) {
    return ErrorDetailModel(
      fieldNameError: (map['fieldNameError'] ?? map['FieldNameError']) ?? '',
      descriptionError: List<String>.from(
        map['descriptionError'] ?? map['DescriptionError'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorDetailModel.fromJson(String source) =>
      ErrorDetailModel.fromMap(json.decode(source));
}
