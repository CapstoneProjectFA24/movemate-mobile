// import local

// utils
import 'package:movemate/features/test_booking/data/models/response/booking_response.dart';
import 'package:movemate/features/test_booking/data/remote/booking_source.dart';
import 'package:movemate/features/test_booking/domain/repositories/booking_repository.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class BookingRepositoryImpl extends RemoteBaseRepository
    implements BookingRepository {
  final bool addDelay;
  final BookingSource _bookingSource;

  BookingRepositoryImpl(this._bookingSource, {this.addDelay = true});

  @override
  Future<BookingResponse> getBookingData() async {
    return getDataOf(
      request: () => _bookingSource.getAllBooking(APIConstants.contentType),
    );
  }
}