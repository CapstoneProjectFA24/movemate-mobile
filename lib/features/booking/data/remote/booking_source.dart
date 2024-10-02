// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/response/booking_response.dart';

import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'booking_source.g.dart';

@RestApi(
    baseUrl: "https://dummyjson.com/c/83a0-09f3-48bb-9368",
    parser: Parser.MapSerializable)
//
abstract class BookingSource {
  factory BookingSource(Dio dio, {String baseUrl}) = _BookingSource;

  @GET('/booking_source')
  Future<HttpResponse<BookingResponse>> getAllBooking(
    @Header(APIConstants.contentHeader) String contentType,
  );
}

@riverpod
BookingSource bookingSource(BookingSourceRef ref) {
  final dio = ref.read(dioProvider);
  return BookingSource(dio);
}
