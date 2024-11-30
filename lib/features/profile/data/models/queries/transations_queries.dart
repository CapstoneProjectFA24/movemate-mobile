import 'dart:convert';

class TransationsQueries {
  final String? search;
  final int page;
  final int perPage;
  final int? userId;
  final String? type;
  final String? sortColumn;
  final int? sortDir;
  //   'SortColumn': 'truckCategoryId',
  // 'SortDir': 0,

  TransationsQueries({
    this.search,
    required this.page,
    this.perPage = 10,
    this.userId,
    this.type,
    this.sortColumn,
    this.sortDir,
    //   'SortColumn': SortColumn?? 'truckCategoryId',
    //   'SortDir': SortDir?? 0,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (search != null) {
      result['Search'] = search;
    }
    result['page'] = page;
    result['per_page'] = perPage;
    if (userId != null) {
      result['UserId'] = userId;
    }
    if (type != null) {
      result['type'] = type;
    }
    if (sortColumn != null) {
      result['SortColumn'] = sortColumn;
    }
    if (sortDir != null) {
      result['SortDir'] = sortDir;
    }

    return result;
  }

  factory TransationsQueries.fromMap(Map<String, dynamic> map) {
    return TransationsQueries(
      search: map['Search'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
      userId: map['UserId']?.toInt(),
      sortDir: map['SortDir']?.toInt(),
      sortColumn: map['SortColumn'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransationsQueries.fromJson(String source) =>
      TransationsQueries.fromMap(json.decode(source));
}
