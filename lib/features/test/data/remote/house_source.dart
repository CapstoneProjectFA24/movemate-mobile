// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/test/data/models/response/house_response.dart';
import 'package:movemate/features/test/data/models/resquest/house_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'house_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class HouseSource {
  factory HouseSource(Dio dio, {String baseUrl}) = _HouseSource;

  @GET(APIConstants.trucks)
  Future<HttpResponse<HouseResponse>> getHouseType(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
    @Queries() HouseRequest request,
  );
}

@riverpod
HouseSource houseSource(HouseSourceRef ref) {
  final dio = ref.read(dioProvider);
  return HouseSource(dio);
}
