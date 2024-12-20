import 'package:dio/dio.dart';
import 'package:movemate/features/profile/data/models/queries/with_draw_queries.dart';
import 'package:movemate/features/profile/data/models/request/unlock_wallet_request.dart';
import 'package:movemate/features/profile/data/models/response/incident_response.dart';
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/models/response/staff_profile_response.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/data/models/response/wallet_response.dart';
import 'package:movemate/models/response/success_model.dart';
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

  // unlock wallet
  @PUT(APIConstants.unlock_wallet)
  Future<HttpResponse<WalletResponse>> unlockWallet(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Body() UnlockWalletRequest request,
  );
  // with draw wallet
  @POST(APIConstants.with_draw)
  Future<HttpResponse<SuccessModel>> withDrawWallet(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() WithDrawQueries amount,
  );

  // get transaction
  @GET(APIConstants.get_transaction)
  Future<HttpResponse<TransactionResponse>> getTransactionByUserId(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() Map<String, dynamic> request,
  );
  // get list incident
  @GET(APIConstants.get_incident_list)
  Future<HttpResponse<IncidentResponse>> getIncidentListByUserId(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() Map<String, dynamic> request,
  );
}

@riverpod
ProfileSource profileSource(ProfileSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ProfileSource(dio);
}
