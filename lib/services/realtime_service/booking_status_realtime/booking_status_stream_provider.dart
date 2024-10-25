import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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