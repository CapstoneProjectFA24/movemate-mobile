import 'dart:convert';

import '../../../../booking/domain/entities/booking_request/resource.dart';

class IncidentRequest {
  final double? price;
  final String? reason;
  List<Resource> resourceList;

  IncidentRequest({
    required this.resourceList,
    this.price,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['resourceList'] = resourceList.map((e) => e.toMap()).toList();
    map['price'] = price;
    map['reason'] = reason;
    return map;
  }

  factory IncidentRequest.fromMap(Map<String, dynamic> map) {
    return IncidentRequest(
      resourceList: List<Resource>.from(
          map['resourceList']?.map((x) => Resource.fromMap(x)) ?? []),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      reason: map['reason'] as String ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IncidentRequest.fromJson(String source) =>
      IncidentRequest.fromMap(json.decode(source));
}
