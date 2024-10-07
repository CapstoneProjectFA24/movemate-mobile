// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/resquest/truck_request.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl
import 'package:movemate/features/booking/data/models/response/services_response.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'service_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ServiceSource {
  factory ServiceSource(Dio dio, {String baseUrl}) = _ServiceSource;


  @GET(APIConstants.get_service)
  Future<HttpResponse<ServicesResponse>> getServices(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
    // @Queries() TruckRequest request,
  );
}

@riverpod
ServiceSource serviceSource(ServiceSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ServiceSource(dio);
}
