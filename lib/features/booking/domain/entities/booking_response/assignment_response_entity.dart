// lib/features/booking/domain/entities/assignment_response_entity.dart

import 'dart:convert';

class AssignmentResponseEntity {
  final int id;
  final int userId;
  final int bookingId;
  final String status;
  final double? price;
  final String staffType;
  final bool? isResponsible;
  AssignmentResponseEntity({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.status,
    this.price,
    required this.staffType,
    this.isResponsible,
  });

  factory AssignmentResponseEntity.fromMap(Map<String, dynamic> json) {
    return AssignmentResponseEntity(
       id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      status: json['status'] ?? '',
      price: json['price'] != null
          ? (json['price'] is double
              ? json['price']
              : (json['price'] is int
                  ? (json['price'] as int).toDouble()
                  : null))
          : null,
      staffType: json['staffType'] ?? '',
      isResponsible: json['isResponsible'] != null
          ? (json['isResponsible'] is bool
              ? json['isResponsible']
              : (json['isResponsible'] is int
                  ? json['isResponsible'] == 1
                  : null))
          : null,
    
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
