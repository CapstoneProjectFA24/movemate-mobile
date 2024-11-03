import 'dart:convert';

class BookingRealtimeEntity {
  final String id;
  final String status;
  final List<AssignmentsRealtimeEntity> assignments;

  BookingRealtimeEntity({
    required this.id,
    required this.status,
    required this.assignments,
  });

  factory BookingRealtimeEntity.fromMap(Map<String, dynamic> data, String id) {
    return BookingRealtimeEntity(
      id: id,
      status: data['Status'],
      assignments: (data['Assignments'] as List<dynamic>?)
              ?.map((e) => AssignmentsRealtimeEntity.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Status': status,
      'Assignments': assignments.map((e) => e.toMap()).toList(),
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
