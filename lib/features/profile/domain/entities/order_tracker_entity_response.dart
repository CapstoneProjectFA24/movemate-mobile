import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/tracker_source_response_entity.dart';

class Owner {
  final int id;
  final int walletId;
  final String name;
  final String phone;
  final String email;
  final String cardHolderName;
  final String bankNumber;
  final String bankName;

  Owner({
    required this.id,
    required this.walletId,
    required this.name,
    required this.phone,
    required this.email,
    required this.cardHolderName,
    required this.bankNumber,
    required this.bankName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'walletId': walletId,
      'name': name,
      'phone': phone,
      'email': email,
      'cardHolderName': cardHolderName,
      'bankNumber': bankNumber,
      'bankName': bankName,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id']?.toInt() ?? 0,
      walletId: map['walletId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      bankNumber: map['bankNumber'] ?? '',
      bankName: map['bankName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) => Owner.fromMap(json.decode(source));
}

class BookingTrackersIncidentEntity {
  final double deposit;
  final String bookingStatus;
  final String pickupAddress;
  final String deliveryAddress;
  final double total;
  final double totalReal;
  final String note;
  final String bookingAt;
  final bool isReviewOnline;
  final bool isInsurance;
  final Owner owner;
  final List<AssignmentResponseEntity> assignments;
  final int id;
  final int bookingId;
  final String time;
  final String type;
  final String location;
  final String point;
  final String status;
  final String description;
  final String title;
  final double estimatedAmount;
  final double? realAmount;
  final String? failedReason;
  final List<TrackerSourceResponseEntity> trackerSources;

  BookingTrackersIncidentEntity({
    required this.deposit,
    required this.bookingStatus,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.total,
    required this.totalReal,
    required this.note,
    required this.bookingAt,
    required this.isReviewOnline,
    required this.isInsurance,
    required this.owner,
    required this.assignments,
    required this.id,
    required this.bookingId,
    required this.time,
    required this.type,
    required this.location,
    required this.point,
    required this.status,
    required this.description,
    required this.title,
    required this.estimatedAmount,
    this.realAmount,
    this.failedReason,
    required this.trackerSources,
  });

  Map<String, dynamic> toMap() {
    return {
      'deposit': deposit,
      'bookingStatus': bookingStatus,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'total': total,
      'totalReal': totalReal,
      'note': note,
      'bookingAt': bookingAt,
      'isReviewOnline': isReviewOnline,
      'isInsurance': isInsurance,
      'owner': owner.toMap(),
      'assignments': assignments.map((x) => x.toMap()).toList(),
      'id': id,
      'bookingId': bookingId,
      'time': time,
      'type': type,
      'location': location,
      'point': point,
      'status': status,
      'description': description,
      'title': title,
      'estimatedAmount': estimatedAmount,
      'realAmount': realAmount,
      'failedReason': failedReason,
      'trackerSources': trackerSources.map((x) => x.toMap()).toList(),
    };
  }

  factory BookingTrackersIncidentEntity.fromMap(Map<String, dynamic> map) {
    return BookingTrackersIncidentEntity(
      deposit: map['deposit']?.toDouble() ?? 0.0,
      bookingStatus: map['bookingStatus'] ?? '',
      pickupAddress: map['pickupAddress'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      totalReal: map['totalReal']?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
      bookingAt: map['bookingAt'] ?? '',
      isReviewOnline: map['isReviewOnline'] ?? false,
      isInsurance: map['isInsurance'] ?? false,
      owner: Owner.fromMap(map['owner']),
      assignments: List<AssignmentResponseEntity>.from(
          map['assignments']?.map((x) => AssignmentResponseEntity.fromMap(x)) ??
              []),
      id: map['id']?.toInt() ?? 0,
      bookingId: map['bookingId']?.toInt() ?? 0,
      time: map['time'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? '',
      point: map['point'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      title: map['title'] ?? '',
      estimatedAmount: map['estimatedAmount']?.toDouble() ?? 0.0,
      realAmount: map['realAmount']?.toDouble(),
      failedReason: map['failedReason'],
      trackerSources: List<TrackerSourceResponseEntity>.from(
          map['trackerSources']
                  ?.map((x) => TrackerSourceResponseEntity.fromMap(x)) ??
              []),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingTrackersIncidentEntity.fromJson(String source) =>
      BookingTrackersIncidentEntity.fromMap(json.decode(source));
}
