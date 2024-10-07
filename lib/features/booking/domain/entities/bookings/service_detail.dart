import 'dart:convert';

class ServiceDetail {
  final int id;
  final bool isQuantity;
  final int quantity;

  ServiceDetail({
    required this.id,
    required this.isQuantity,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isQuantity': isQuantity,
      'quantity': quantity,
    };
  }

  factory ServiceDetail.fromMap(Map<String, dynamic> map) {
    return ServiceDetail(
      id: map['id'],
      isQuantity: map['isQuantity'],
      quantity: map['quantity'],
    );
  }
}

class Resource {
  final String type;
  final String resourceUrl;
  final String resourceCode;

  Resource({
    required this.type,
    required this.resourceUrl,
    required this.resourceCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'resourceUrl': resourceUrl,
      'resourceCode': resourceCode,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      type: map['type'],
      resourceUrl: map['resourceUrl'],
      resourceCode: map['resourceCode'],
    );
  }
}

class BookingRequest {
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
  final List<ServiceDetail> serviceDetails;
  final int truckCategoryId;
  final String bookingAt;
  final List<Resource> resourceList;

  BookingRequest({
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
    required this.resourceList,
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
      'bookingAt': bookingAt,
      'resourceList': resourceList.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

