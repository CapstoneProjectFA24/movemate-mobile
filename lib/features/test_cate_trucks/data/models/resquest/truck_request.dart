import 'dart:convert';

class TruckRequest {
  // final String? systemStatus;
  // final String? partnerOrderStatus;
  // final String? searchDateFrom;
  // final String? searchDateTo;
  final String? search;
  final int page;
  final int perPage;

  TruckRequest({
    // this.systemStatus,
    // this.partnerOrderStatus,
    // this.searchDateFrom,
    // this.searchDateTo,
    this.search,
    required this.page,
    this.perPage = 10,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // if (systemStatus != null) {
    //   result.addAll({'systemStatus': systemStatus});
    // }
    // if (partnerOrderStatus != null) {
    //   result.addAll({'partnerOrderStatus': partnerOrderStatus});
    // }
    // if (searchDateFrom != null) {
    //   result.addAll({'searchDateFrom': searchDateFrom});
    // }
    // if (searchDateTo != null) {
    //   result.addAll({'searchDateTo': searchDateTo});
    // }
    if (search != null) {
      result.addAll({'Search': search});
    }
    result.addAll({'page': page});
    result.addAll({'per_page': perPage});

    return result;
  }

  factory TruckRequest.fromMap(Map<String, dynamic> map) {
    return TruckRequest(
      // systemStatus: map['systemStatus'],
      // partnerOrderStatus: map['partnerOrderStatus'],
      // searchDateFrom: map['searchDateFrom'],
      // searchDateTo: map['searchDateTo'],
      search: map['Search'],
      page: map['page']?.toInt() ?? 1,
      perPage: map['per_page']?.toInt() ?? 10,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SignUpRequest(search: $search, page: $page, perPage: $perPage)';
  }

  factory TruckRequest.fromJson(String source) =>
      TruckRequest.fromMap(json.decode(source));
}
