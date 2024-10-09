// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl


// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'house_type_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class HouseTypeSource {
  factory HouseTypeSource(Dio dio, {String baseUrl}) = _HouseTypeSource;


  @GET(APIConstants.get_house_types)
  Future<HttpResponse<HouseTypeResponse>> getHouseTypes(
    @Header(APIConstants.contentHeader) String contentType,
    // @Header(APIConstants.authHeader) String accessToken,
    // @Queries() TruckRequest request,
  );
}

@riverpod
HouseTypeSource houseTypeSource(HouseTypeSourceRef ref) {
  final dio = ref.read(dioProvider);
  return HouseTypeSource(dio);
}
