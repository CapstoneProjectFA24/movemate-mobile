//rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/testapi/data/models/house_response.dart';
import 'package:movemate/utils/providers/common_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//data iml

//ultils
import 'package:movemate/utils/constants/api_constant.dart';

part 'house_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class HouseSource {
  factory HouseSource(Dio dio, {String baseUrl}) = _HouseSource;

  @GET(APIConstants.houseType)
  Future<HttpResponse<HouseResponse>> getHousesTypes(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
}

@riverpod
HouseSource houseSource(HouseSourceRef ref) {
  final dio = ref.read(dioProvider);
  return HouseSource(dio);
}
