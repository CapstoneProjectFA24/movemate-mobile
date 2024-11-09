// lib/features/booking/domain/entities/booking_detail_response_entity.dart

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
        ')';
  }

  factory BookingDetailResponseEntity.fromJson(String source) =>
      BookingDetailResponseEntity.fromMap(json.decode(source));
}
