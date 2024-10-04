import 'dart:convert';

class TruckRequest {
  final int page;
  final int perPage;
  final String? search;

  TruckRequest({
    required this.page,
    this.perPage = 10,
    this.search,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'page': page});
    result.addAll({'per_page': perPage});
    if (search != null) {
      result.addAll({'Search': search});
    }

    return result;
  }

  factory TruckRequest.fromMap(Map<String, dynamic> map) {
    return TruckRequest(
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
       search: map['Search'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SignUpRequest(page: $page, perPage: $perPage, search : $search)';
  }

  factory TruckRequest.fromJson(String source) =>
      TruckRequest.fromMap(json.decode(source));
}
