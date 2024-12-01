import 'package:dio/dio.dart';
import 'package:movemate/features/promotion/data/models/request/promotion_request.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'promotion_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class PromotionSource {
  factory PromotionSource(Dio dio, {String baseUrl}) = _PromotionSource;

  @GET(APIConstants.promotions)
  Future<HttpResponse<PromotionResponse>> getPromotions(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() PromotionQueryRequest request,
  );
}

@riverpod
PromotionSource promotionSource(PromotionSourceRef ref) {
  final dio = ref.read(dioProvider);
  return PromotionSource(dio);
}
