import 'package:dio/dio.dart';
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'order_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class OrderSource {
  factory OrderSource(Dio dio, {String baseUrl}) = _OrderSource;

  @GET(APIConstants.bookings)
  Future<HttpResponse<OrderReponse>> getBookings(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
  );
}

@riverpod
OrderSource orderSource(OrderSourceRef ref) {
  final dio = ref.read(dioProvider);
  return OrderSource(dio);
}
