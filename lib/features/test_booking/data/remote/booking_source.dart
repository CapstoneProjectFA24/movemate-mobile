// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/test_booking/data/models/response/booking_response.dart';

import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'booking_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class BookingSource {
  factory BookingSource(Dio dio, {String baseUrl}) = _BookingSource;

  @GET(APIConstants.get_all_bookings)
  Future<HttpResponse<BookingResponse>> getAllBooking(
    @Header(APIConstants.contentHeader) String contentType,
  );
}

@riverpod
BookingSource bookingSource(BookingSourceRef ref) {
  final dio = ref.read(dioProvider);
  return BookingSource(dio);
}
