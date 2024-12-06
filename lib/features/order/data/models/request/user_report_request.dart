import 'dart:convert';

import '../../../../booking/domain/entities/booking_request/resource.dart';

class UserReportRequest {
  final int bookingId;
  final String? location;
  final String? point;
  final String? description;
  final String? title;
  final double? estimatedAmount;
  final bool? isInsurance;
  final String? reason;
  List<Resource> resourceList;

  UserReportRequest({
    required this.resourceList,
    required this.bookingId,
    this.reason,
    this.location,
    this.point,
    this.description,
    this.title,
    this.estimatedAmount,
    this.isInsurance,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['bookingId'] = bookingId;
    map['resourceList'] = resourceList.map((e) => e.toMap()).toList();
    map['reason'] = reason;
    map['location'] = location;
    map['point'] = point;
    map['description'] = description;
    map['title'] = title;
    map['estimatedAmount'] = estimatedAmount;
    map['isInsurance'] = isInsurance;

    return map;
  }

  factory UserReportRequest.fromMap(Map<String, dynamic> map) {
    return UserReportRequest(
      resourceList: List<Resource>.from(
          map['resourceList']?.map((x) => Resource.fromMap(x)) ?? []),
      reason: map['reason'] as String ?? '',
      location: map['location'] as String ?? '',
      point: map['point'] as String ?? '',
      description: map['description'] as String ?? '',
      title: map['title'] as String ?? '',
      estimatedAmount: map['estimatedAmount'] as double ?? 0.0,
      isInsurance: map['isInsurance'] as bool ?? false,
      bookingId: map['bookingId'] as int ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserReportRequest(bookingId: $bookingId, location: $location, point: $point, description: $description, title: $title, estimatedAmount: $estimatedAmount, isInsurance: $isInsurance, reason: $reason, resourceList: $resourceList)';
  }

  factory UserReportRequest.fromJson(String source) =>
      UserReportRequest.fromMap(json.decode(source));
}

// {
//   "bookingId": 0,
//   "location": "string",
//   "point": "string",
//   "description": "string",
//   "title": "string",
//   "estimatedAmount": 0,
//   "isInsurance": true,
//   "resourceList": [
//     {
//       "type": "string",
//       "resourceUrl": "string",
//       "resourceCode": "string"
//     }
//   ]
// }