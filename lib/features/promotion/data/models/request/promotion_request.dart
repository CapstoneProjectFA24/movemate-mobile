import 'dart:convert';

class PromotionQueryRequest {
  final String? search;
  final int page;
  final int perPage;
  // final int sortColumn ;

  PromotionQueryRequest({
    this.search,
    required this.page,
    this.perPage = 10,
    // required this.sortColumn,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (search != null) {
      result.addAll({'Search': search});
    }
    result.addAll({'page': page});
    result.addAll({'per_page': perPage});
    // result.addAll({'SortColumn': sortColumn});

    return result;
  }

  factory PromotionQueryRequest.fromMap(Map<String, dynamic> map) {
    return PromotionQueryRequest(
      search: map['Search'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
      // sortColumn: map['sortColumn']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionQueryRequest.fromJson(String source) =>
      PromotionQueryRequest.fromMap(json.decode(source));
}
