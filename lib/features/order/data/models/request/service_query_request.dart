import 'dart:convert';


class ServiceQueryRequest {
  final String? search;
  final String? type;
  final int page;
  final int perPage;
  // final int UserId;

  ServiceQueryRequest({
    this.search,
    this.type,
    required this.page,
    this.perPage = 10,
    // required this.UserId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (search != null) {
      result.addAll({'Search': search});
    }
    if (type != null) {
      result.addAll({'Type': type});
    }
    result.addAll({'page': page});
    result.addAll({'per_page': perPage});
    // result.addAll({'UserId': UserId});

    return result;
  }

  factory ServiceQueryRequest.fromMap(Map<String, dynamic> map) {
    return ServiceQueryRequest(
      search: map['Search'],
      type: map['Type'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
      // UserId: map['UserId']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceQueryRequest.fromJson(String source) =>
      ServiceQueryRequest.fromMap(json.decode(source));
}
