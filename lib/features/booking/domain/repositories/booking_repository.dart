import 'package:movemate/features/booking/data/models/response/booking_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movemate/features/booking/data/remote/booking_source.dart';
import 'package:movemate/features/booking/data/repositories/booking_repository_impl.dart';

part 'booking_repository.g.dart';

abstract class BookingRepository {
  Future<BookingResponse> getBookingData();
}

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  final bookingSource = ref.read(bookingSourceProvider);
  return BookingRepositoryImpl(bookingSource);
}
