// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';

import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'services_fee_system_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ServicesFeeSystemSource {
  factory ServicesFeeSystemSource(Dio dio, {String baseUrl}) =
      _ServicesFeeSystemSource;

  @GET(APIConstants.get_fees_system)
  Future<HttpResponse<ServicesFeeSystemResponse>> getFeeSystems(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
    // @Queries() TruckRequest request,
  );
}

@riverpod
ServicesFeeSystemSource servicesFeeSystemSource(
    ServicesFeeSystemSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ServicesFeeSystemSource(dio);
}
