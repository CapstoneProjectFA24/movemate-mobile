// service_booking_source.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import response models
import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';

// Utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'service_booking_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ServiceBookingSource {
  factory ServiceBookingSource(Dio dio, {String baseUrl}) =
      _ServiceBookingSource;

  // House Types
  @GET(APIConstants.get_house_types)
  Future<HttpResponse<HouseTypeResponse>> getHouseTypes(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );

  // Services
  @GET(APIConstants.get_service)
  Future<HttpResponse<ServicesResponse>> getServices(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );

  // System Fees
  @GET(APIConstants.get_fees_system)
  Future<HttpResponse<ServicesFeeSystemResponse>> getFeeSystems(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );

  // Package Services
  @GET(APIConstants.get_package_services)
  Future<HttpResponse<ServicesPackageResponse>> getPackageServices(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
//Post , put
}

@riverpod
ServiceBookingSource serviceBookingSource(ServiceBookingSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ServiceBookingSource(dio);
}
