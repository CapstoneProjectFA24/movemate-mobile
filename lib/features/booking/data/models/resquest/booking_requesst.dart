// POST /api/v1/bookings/register-booking
// {
//   "pickupAddress": "string",
//   "pickupPoint": "string",
//   "deliveryAddress": "string",
//   "deliveryPoint": "string",
//   "estimatedDistance": "3",
//   "houseTypeId": 1,
//   "note": "string",
//   "estimatedDeliveryTime": "3",
//   "isRoundTrip": true,
//   "isManyItems": true,
//   "roomNumber": "1",
//   "floorsNumber": "2",
//   "serviceDetails": [
//     {
//       "id": 1,
//       "isQuantity": true,
//       "quantity": 1
//     }
//   ],
//   "truckCategoryId": 1,
//   "bookingAt": "2024-09-27T04:05:29.705Z",
//   "resourceList": [
//     {
//       "type": "IMG",
//       "resourceUrl": "https://hoanghamobile.com/tin-tuc/wp-content/webp-express/webp-images/uploads/2024/03/anh-meme-hai.jpg.webp",
//       "resourceCode": "string"
//     }
//   ]
// }

import 'dart:convert';

import 'package:movemate/features/booking/data/models/resquest/services_detail_request.dart';

class BookingRequesst {
  final String pickupAddress;
  final String pickupPoint;
  final String deliveryAddress;
  final String deliveryPoint;
  final String estimatedDistance;
  final int houseTypeId;
  final String note;
  final String estimatedDeliveryTime;
  final bool isRoundTrip;
  final bool isManyItems;
  final String roomNumber;
  final String floorsNumber;
  final List<ServicesDetailRequest> serviceDetails;
  final int truckCategoryId;
  final DateTime bookingAt;

  BookingRequesst({
    required this.pickupAddress,
    required this.pickupPoint,
    required this.deliveryAddress,
    required this.deliveryPoint,
    required this.estimatedDistance,
    required this.houseTypeId,
    required this.note,
    required this.estimatedDeliveryTime,
    required this.isRoundTrip,
    required this.isManyItems,
    required this.roomNumber,
    required this.floorsNumber,
    required this.serviceDetails,
    required this.truckCategoryId,
    required this.bookingAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupAddress': pickupAddress,
      'pickupPoint': pickupPoint,
      'deliveryAddress': deliveryAddress,
      'deliveryPoint': deliveryPoint,
      'estimatedDistance': estimatedDistance,
      'houseTypeId': houseTypeId,
      'note': note,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'isRoundTrip': isRoundTrip,
      'isManyItems': isManyItems,
      'roomNumber': roomNumber,
      'floorsNumber': floorsNumber,
      'serviceDetails': serviceDetails.map((x) => x.toMap()).toList(),
      'truckCategoryId': truckCategoryId,
      'bookingAt': bookingAt.toIso8601String(),
    };
  }

  factory BookingRequesst.fromMap(Map<String, dynamic> map) {
    return BookingRequesst(
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      estimatedDistance: map['estimatedDistance'] ?? '0',
      houseTypeId: map['houseTypeId']?.toInt() ?? 0,
      note: map['note'] ?? '',
      estimatedDeliveryTime: map['estimatedDeliveryTime'] ?? '0',
      isRoundTrip: map['isRoundTrip'] ?? false,
      isManyItems: map['isManyItems'] ?? false,
      roomNumber: map['roomNumber'] ?? '0',
      floorsNumber: map['floorsNumber'] ?? '0',
      serviceDetails: List<ServicesDetailRequest>.from(
          map['serviceDetails']?.map((x) => ServicesDetailRequest.fromMap(x)) ??
              const []),
      truckCategoryId: map['truckCategoryId']?.toInt() ?? 0,
      bookingAt: DateTime.parse(map['bookingAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingRequesst.fromJson(String source) =>
      BookingRequesst.fromMap(json.decode(source));
}
