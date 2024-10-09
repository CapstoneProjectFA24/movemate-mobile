// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/response/trucks_response.dart';
import 'package:movemate/features/booking/data/models/resquest/truck_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'truck_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class TruckSource {
  factory TruckSource(Dio dio, {String baseUrl}) = _TruckSource;

  @GET(APIConstants.get_truck_category)
  Future<HttpResponse<TruckResponse>> getTrucks(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
    @Queries() TruckRequest request,
  );
}

@riverpod
TruckSource truckSource(TruckSourceRef ref) {
  final dio = ref.read(dioProvider);
  return TruckSource(dio);
}
