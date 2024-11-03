// import local
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/remote/profile_source.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
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
      request: () => _profileSource.getProfileInfor(APIConstants.contentType, accessToken),
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
}
