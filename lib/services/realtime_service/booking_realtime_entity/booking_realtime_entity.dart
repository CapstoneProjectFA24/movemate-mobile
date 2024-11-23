import 'dart:convert';

class BookingRealtimeEntity {
  final String id;
  final String status;
  final List<AssignmentsRealtimeEntity> assignments;
  final double deposit;
  final double total;
  final double totalFee;
  final double totalReal;

  BookingRealtimeEntity({
    required this.id,
    required this.status,
    required this.assignments,
    required this.deposit,
    required this.total,
    required this.totalFee,
    required this.totalReal,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Status': status,
      'Assignments': assignments.map((e) => e.toMap()).toList(),
      'Deposit': deposit,
      'Total': total,
      'TotalFee': totalFee,
      'TotalReal': totalReal,
    };
  }

  String toJson() => json.encode(toMap());
}

class AssignmentsRealtimeEntity {
  final String status;
  final String staffType;

  AssignmentsRealtimeEntity({
    required this.status,
    required this.staffType,
  });

  factory AssignmentsRealtimeEntity.fromMap(Map<String, dynamic> data) {
    return AssignmentsRealtimeEntity(
      status: data['Status'],
      staffType: data['StaffType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Status': status,
      'StaffType': staffType,
    };
  }

  String toJson() => json.encode(toMap());
}
