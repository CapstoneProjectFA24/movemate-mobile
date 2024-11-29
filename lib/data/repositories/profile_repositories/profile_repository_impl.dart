// import local
import 'package:movemate/data/models/response/profile_response/profile_response.dart';
import 'package:movemate/data/models/response/profile_response/staff_profile_response.dart';
import 'package:movemate/data/models/response/profile_response/wallet_response.dart';
import 'package:movemate/data/remote/profile_remote/profile_source.dart';
import 'package:movemate/domain/repositories/profile_repositories/profile_repository.dart';
import 'package:movemate/data/models/request/paging_model.dart';
import 'package:movemate/utils/constants/api_constant.dart';

// utils
import 'package:movemate/utils/resources/remote_base_repository.dart';

class ProfileRepositoryImpl extends RemoteBaseRepository
    implements ProfileRepository {
  final bool addDelay;
  final ProfileSource _profileSource;

  ProfileRepositoryImpl(this._profileSource, {this.addDelay = true});

  @override
  Future<ProfileResponse> getProfileInfor({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () =>
          _profileSource.getProfileInfor(APIConstants.contentType, accessToken),
    );
  }

  @override
  Future<ProfileResponse> getProfileInforById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _profileSource.getProfileInforById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }
  @override
  Future<StaffProfileResponse> getProfileDriverInforById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _profileSource.getProfileDriverInforById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<WalletResponse> getWallet({
    //  PagingModel? request,
    required String accessToken,
  }) async {
    print("check repo");
    return getDataOf(
      request: () => _profileSource.getWallet(
        APIConstants.contentType,
        accessToken,
      ),
    );
  }
}