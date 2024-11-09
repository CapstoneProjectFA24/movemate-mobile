import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

final orderStatusStreamProvider =
    StreamProvider.family<BookingStatusType, String>((ref, bookingId) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingId)
      .snapshots()
      .map((snapshot) {
    final statusString = snapshot.data()?['Status'] as String? ?? 'PENDING';
    return statusString.toBookingTypeEnum();
  });
});

// final orderStatusAssignmentStreamProvider =
//     StreamProvider.family<List<AssignmentsStatusType>, String>(
//         (ref, bookingId) {
//   return FirebaseFirestore.instance
//       .collection('bookings')
//       .doc(bookingId)
//       .snapshots()
//       .map((snapshot) {
//     final assignments = snapshot.data()?['Assignments'] as List<dynamic>? ?? [];
//     final statusList = assignments.map((assignment) {
//       final statusString = assignment['Status'] as String? ?? 'ASSIGNED';
//       return statusString.toAssignmentsTypeEnum();
//     }).toList();
//     return statusList;
//   });
// });

final bookingStreamProvider =
    StreamProvider.family<BookingRealtimeEntity, String>(
        (ref, String bookingId) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingId)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      throw Exception('Booking not found');
    }

    final data = snapshot.data();

    return BookingRealtimeEntity.fromMap(data!, bookingId);
  });
});