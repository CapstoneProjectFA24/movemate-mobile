import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// model system
import 'package:movemate/models/response/success_model.dart';

// data impl
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';
import 'package:movemate/features/auth/data/models/request/otp_verify_request.dart';
import 'package:movemate/features/auth/data/models/request/sign_in_request.dart';
import 'package:movemate/features/auth/data/models/response/account_response.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'auth_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class AuthSource {
  factory AuthSource(Dio dio, {String baseUrl}) = _AuthSource;

  @POST(APIConstants.login)
  Future<HttpResponse<AccountReponse>> signIn(
    @Body() SignInRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );

  @POST(APIConstants.register)
  Future<HttpResponse<SuccessModel>> signUp(
    @Body() SignUpRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );

  @POST(APIConstants.checkExists)
  Future<HttpResponse<SuccessModel>> checkValidUser(
    @Body() SignUpRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );

  @POST(APIConstants.verifyToken)
  Future<HttpResponse<SuccessModel>> verifyToken(
    @Body() OTPVerifyRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );

  @POST(APIConstants.register)
  Future<HttpResponse<AccountReponse>> signUpAndRes(
    @Body() SignUpRequest request,
    @Header(APIConstants.contentHeader) String contentType,
  );
}

@riverpod
AuthSource authSource(AuthSourceRef ref) {
  final dio = ref.read(dioProvider);
  return AuthSource(dio);
}
