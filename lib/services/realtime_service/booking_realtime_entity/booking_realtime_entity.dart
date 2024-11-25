import 'dart:convert';

class BookingRealtimeEntity {
  final String id;
  final String status;
  final List<AssignmentsRealtimeEntity> assignments;
  final double deposit;
  final double total;
  final double totalFee;
  final double totalReal;
  final List<BookingDetailRealTimeEntity> bookingDetails;

  BookingRealtimeEntity({
    required this.id,
    required this.status,
    required this.assignments,
    required this.deposit,
    required this.total,
    required this.totalFee,
    required this.totalReal,
    required this.bookingDetails,
  });

  factory BookingRealtimeEntity.fromMap(Map<String, dynamic> data, String id) {
    return BookingRealtimeEntity(
      id: id,
      status: data['Status'] ?? '',
      assignments: (data['Assignments'] as List<dynamic>?)
              ?.map((e) => AssignmentsRealtimeEntity.fromMap(e))
              .toList() ??
          [],
      deposit: (data['Deposit'] as num?)?.toDouble() ?? 0.0,
      total: (data['Total'] as num?)?.toDouble() ?? 0.0,
      totalFee: (data['TotalFee'] as num?)?.toDouble() ?? 0.0,
      totalReal: (data['TotalReal'] as num?)?.toDouble() ?? 0.0,
      bookingDetails: (data['BookingDetails'] as List<dynamic>?)
              ?.map((e) => BookingDetailRealTimeEntity.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Status': status,
      'Assignments': assignments.map((e) => e.toMap()).toList(),
      'BookingDetails': bookingDetails.map((e) => e.toMap()).toList(),
      'Deposit': deposit,
      'Total': total,
      'TotalFee': totalFee,
      'TotalReal': totalReal,
    };
  }

  String toJson() => json.encode(toMap());
}

class AssignmentsRealtimeEntity {
  final int bookingId;
  final String status;
  final String staffType;
  final bool isResponsible;
  final int userId;

  AssignmentsRealtimeEntity({
    required this.status,
    required this.staffType,
    required this.isResponsible,
    required this.userId,
    required this.bookingId,
  });

  factory AssignmentsRealtimeEntity.fromMap(Map<String, dynamic> data) {
    return AssignmentsRealtimeEntity(
      bookingId: data['BookingId'] ?? 0, // Cung cấp giá trị mặc định
      status: data['Status'] ?? '',
      staffType: data['StaffType'] ?? '',
      isResponsible:
          data['IsResponsible'] ?? false, // Mặc định là false nếu null
      userId: data['UserId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Status': status,
      'StaffType': staffType,
      'IsResponsible': isResponsible,
      'UserId': userId,
      'BookingId': bookingId,
    };
  }

  String toJson() => json.encode(toMap());
}

class BookingDetailRealTimeEntity {
  final int id;
  final int serviceId;
  final int bookingId;
  final int quantity;
  final double price;
  final String status;
  final String type;
  final String name;
  final String? description;
  final String? imageUrl;

  BookingDetailRealTimeEntity({
    required this.id,
    required this.serviceId,
    required this.bookingId,
    required this.quantity,
    required this.price,
    required this.status,
    required this.type,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory BookingDetailRealTimeEntity.fromMap(Map<String, dynamic> data) {
    return BookingDetailRealTimeEntity(
      id: data['id'] ?? 0,
      serviceId: data['serviceId'] ?? 0,
      bookingId: data['bookingId'] ?? 0,
      quantity: data['quantity'] ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
      type: data['type'] ?? '',
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
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

  static List<BookingDetailRealTimeEntity> fromList(List<dynamic> list) {
    return list
        .map((item) => BookingDetailRealTimeEntity.fromMap(item))
        .toList();
  }
}
