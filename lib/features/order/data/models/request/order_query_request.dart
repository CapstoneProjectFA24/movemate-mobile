import 'dart:convert';

class OrderQueryRequest {
  final String? search;
  final int page;
  final int perPage;
  final int UserId;

  OrderQueryRequest({
    this.search,
    required this.page,
    this.perPage = 10,
    required this.UserId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (search != null) {
      result.addAll({'Search': search});
    }
    result.addAll({'page': page});
    result.addAll({'per_page': perPage});
    result.addAll({'UserId': UserId});

    return result;
  }

  factory OrderQueryRequest.fromMap(Map<String, dynamic> map) {
    return OrderQueryRequest(
      search: map['Search'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
      UserId: map['UserId']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderQueryRequest.fromJson(String source) =>
      OrderQueryRequest.fromMap(json.decode(source));
}
