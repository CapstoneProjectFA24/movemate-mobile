import 'dart:convert';

// BookingAt : "12/08/2024 00:33:00"
class BookingRealtimeEntity {
  final String id;
  final String status;
  final List<AssignmentsRealtimeEntity> assignments;
  final double deposit;
  final double total;
  final double totalFee;
  final double totalReal;
  final bool isCredit;
  final String bookingAt;
  final bool isCancel;
  final bool isRefunded;
  final bool isReported;
  final List<BookingDetailRealTimeEntity> bookingDetails;
  // final List<VouchersRealtimeEntity> vouchers;

  BookingRealtimeEntity({
    required this.id,
    required this.status,
    required this.assignments,
    required this.deposit,
    required this.total,
    required this.totalFee,
    required this.totalReal,
    required this.isCredit,
    required this.bookingAt,
    required this.isCancel,
    required this.isRefunded,
    required this.isReported,
    required this.bookingDetails,
    // required this.vouchers,
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
      isCredit: data['IsCredit'] as bool,
      isCancel: data['IsCancel'] as bool,
      isRefunded: data['IsRefunded'] as bool,
      bookingAt: data['BookingAt'] ?? "12/08/2024 00:00:00",
      isReported: data['IsReported'] as bool,
      bookingDetails: (data['BookingDetails'] as List<dynamic>?)
              ?.map((e) => BookingDetailRealTimeEntity.fromMap(e))
              .toList() ??
          [],
      // vouchers: (data['Vouchers'] as List<dynamic>?)
      //         ?.map((e) => VouchersRealtimeEntity.fromMap(e))
      //         .toList() ??
      //     [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Status': status,
      'Assignments': assignments.map((e) => e.toMap()).toList(),
      'BookingDetails': bookingDetails.map((e) => e.toMap()).toList(),
      // 'Vouchers': vouchers.map((e) => e.toMap()).toList(),
      'Deposit': deposit,
      'Total': total,
      'TotalFee': totalFee,
      'IsCredit': isCredit,
      'IsCancel': isCancel,
      'IsRefunded': isRefunded,
      'BookingAt': bookingAt,
      'IsReported': isReported,
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

  @override
  String toString() {
    return 'AssignmentsRealtimeEntity('
        'userId: $userId, '
        'status: $status, '
        'bookingId: $bookingId, '
        'staffType: $staffType, '
        'isResponsible: $isResponsible, '
        'status: $status, '
        ')';
  }
}

class VouchersRealtimeEntity {
  final int? bookingId;
  final String code;
  final int id;
  final bool isActived;
  final double price;
  final int promotionCategoryId;
  final int? userId;

  VouchersRealtimeEntity({
    this.bookingId,
    required this.code,
    required this.id,
    required this.isActived,
    required this.price,
    required this.promotionCategoryId,
    this.userId,
  });

  factory VouchersRealtimeEntity.fromMap(Map<String, dynamic> data) {
    return VouchersRealtimeEntity(
      bookingId: data['BookingId'] ?? 0, // Cung cấp giá trị mặc định
      code: data['Code'] ?? '',
      id: data['Id'] ?? '',
      // isActived: data['IsActived'] ?? false, // Mặc định là false nếu null
      isActived: data['isActived'] as bool,
      price: (data['Price'] as num?)?.toDouble() ?? 0,
      promotionCategoryId: data['PromotionCategoryId'] ?? 0,
      userId: data['UserId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'BookingId': bookingId,
      'Code': code,
      'Id': id,
      'IsActived': isActived,
      'Price': price,
      'PromotionCategoryId': promotionCategoryId,
      'UserId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'AssignmentsRealtimeEntity('
        'bookingId: $bookingId, '
        'code: $code, '
        'IsActived: $isActived, '
        'Price: $price, '
        'id: $id, '
        'promotionCategoryId: $promotionCategoryId, '
        'userId: $userId, '
        ')';
  }
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
      id: data['Id'] ?? 0,
      serviceId: data['ServiceId'] ?? 0,
      bookingId: data['BookingId'] ?? 0,
      quantity: data['Quantity'] ?? 0,
      price: (data['Price'] as num?)?.toDouble() ?? 0.0,
      status: data['Status'] ?? '',
      type: data['Type'] ?? '',
      name: data['Name'] ?? '',
      description: data['Description'] ?? '',
      imageUrl: data['ImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'ServiceId': serviceId,
      'BookingId': bookingId,
      'Quantity': quantity,
      'Price': price,
      'Status': status,
      'Type': type,
      'Name': name,
      'Description': description,
      'ImageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  static List<BookingDetailRealTimeEntity> fromList(List<dynamic> list) {
    return list
        .map((item) => BookingDetailRealTimeEntity.fromMap(item))
        .toList();
  }
}
