import 'dart:convert';

class TruckQueries {
  final String? search;
  final int page;
  final int perPage;
  final int? userId;
  final String? type;

  TruckQueries({
    this.search,
    required this.page,
    this.perPage = 10,
    this.userId,
    this.type,
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

    return result;
  }

  factory TruckQueries.fromMap(Map<String, dynamic> map) {
    return TruckQueries(
      search: map['Search'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
      userId: map['UserId']?.toInt(),
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckQueries.fromJson(String source) =>
      TruckQueries.fromMap(json.decode(source));
}
