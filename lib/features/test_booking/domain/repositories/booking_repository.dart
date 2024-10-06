import 'package:movemate/features/test_booking/data/models/response/booking_response.dart';
import 'package:movemate/features/test_booking/data/remote/booking_source.dart';
import 'package:movemate/features/test_booking/data/repositories/booking_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_repository.g.dart';

abstract class BookingRepository {
  Future<BookingResponse> getBookingData();
}

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  final bookingSource = ref.read(bookingSourceProvider);
  return BookingRepositoryImpl(bookingSource);
}
