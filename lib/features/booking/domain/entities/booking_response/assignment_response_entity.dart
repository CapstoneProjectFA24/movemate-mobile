// lib/features/booking/domain/entities/assignment_response_entity.dart

import 'dart:convert';

class AssignmentResponseEntity {
  final int id;
  final int userId;
  final int bookingId;
  final String status;
  final double price;
  final String staffType;
  final bool isResponsible;

  AssignmentResponseEntity({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.status,
    required this.price,
    required this.staffType,
    required this.isResponsible,
  });

  factory AssignmentResponseEntity.fromMap(Map<String, dynamic> json) {
    return AssignmentResponseEntity(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      status: json['status'] ?? '',
      price: json['price'] ?? 0,
      staffType: json['staffType'] ?? '',
      isResponsible: json['isResponsible'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookingId': bookingId,
      'status': status,
      'price': price,
      'staffType': staffType,
      'isResponsible': isResponsible,
    };
  }

  String toJson() => json.encode(toMap());

  factory AssignmentResponseEntity.fromJson(String source) =>
      AssignmentResponseEntity.fromMap(json.decode(source));
}
