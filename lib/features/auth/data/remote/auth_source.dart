import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// model system
import 'package:movemate/models/response/success_model.dart';

// data impl
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'auth_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class AuthSource {
  factory AuthSource(Dio dio, {String baseUrl}) = _AuthSource;

  @POST(APIConstants.register)
  Future<HttpResponse<SuccessModel>> signUp(
    @Body() SignUpRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );
}

@riverpod
AuthSource authSource(AuthSourceRef ref) {
  final dio = ref.read(dioProvider);
  return AuthSource(dio);
}
