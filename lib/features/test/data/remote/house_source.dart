// rest API
import 'package:dio/dio.dart';
import 'package:movemate/features/test/data/models/house_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl
import 'package:movemate/features/test/data/models/house_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'house_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class HouseSource {
  factory HouseSource(Dio dio, {String baseUrl}) = _HouseSource;

  @GET(APIConstants.house_type)
  Future<HttpResponse<HouseResponse>> getHouseType(
    @Header(APIConstants.contentHeader) String contentType,
  );
}

@riverpod
HouseSource houseSource(HouseSourceRef ref) {
  final dio = ref.read(dioProvider);
  return HouseSource(dio);
}
