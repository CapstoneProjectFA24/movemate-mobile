// lib/features/booking/domain/entities/booking_detail_response_entity.dart
//  "id": 143,
//         "serviceId": 12,
//         "bookingId": 34,
//         "quantity": 1,
//         "price": 148500,
//         "status": "AVAILABLE",
//         "type": "TRUCK",
//         "name": "Xe tải 1000kg",
//         "description": "Cấm tải 6-9h & 16-20h",
//         "imageUrl": "https://utfs.io/f/yYv3QHy7AjsNa1n5qlcN0WIECY7qV85KdQoXSGufv9LwUlHF"
import 'dart:convert';

class BookingDetailResponseEntity {
  final int id;
  final int serviceId;
  final int bookingId;
  final int quantity;
  final double price;
  final String status;
  final String type;
  final String name;
  final String description;
  final String imageUrl;

  BookingDetailResponseEntity({
    required this.id,
    required this.serviceId,
    required this.bookingId,
    required this.quantity,
    required this.price,
    required this.status,
    required this.type,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory BookingDetailResponseEntity.fromMap(Map<String, dynamic> json) {
    return BookingDetailResponseEntity(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'bookingId': bookingId,
      'quantity': quantity,
      'price': price,
      'status': status,
      'type': type,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'BookingDetailResponseEntity('
        'id: $id, '
        'serviceId: $serviceId, '
        'bookingId: $bookingId, '
        'quantity: $quantity, '
        'price: $price, '
        'status: $status, '
        'type: $type, '
        'name: $name, '
        'description: $description'
        'imageUrl: $imageUrl'
        ')';
  }

  factory BookingDetailResponseEntity.fromJson(String source) =>
      BookingDetailResponseEntity.fromMap(json.decode(source));
}
