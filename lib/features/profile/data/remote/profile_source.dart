import 'package:dio/dio.dart';
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/models/response/staff_profile_response.dart';
import 'package:movemate/features/profile/data/models/response/wallet_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'profile_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ProfileSource {
  factory ProfileSource(Dio dio, {String baseUrl}) = _ProfileSource;
  // House Types
  @GET(APIConstants.get_user)
  Future<HttpResponse<ProfileResponse>> getProfileInfor(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
  // house types get by id
  @GET('${APIConstants.get_user}/{id}')
  Future<HttpResponse<ProfileResponse>> getProfileInforById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );
  @GET('${APIConstants.get_user}/{id}')
  Future<HttpResponse<StaffProfileResponse>> getProfileDriverInforById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );

  // get wallet
  @GET(APIConstants.get_wallet)
  Future<HttpResponse<WalletResponse>> getWallet(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
}

@riverpod
ProfileSource profileSource(ProfileSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ProfileSource(dio);
}
