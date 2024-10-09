// import local
import 'package:movemate/features/profile/data/remote/profile_source.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:retrofit/dio.dart';

class ProfileRepositoryImpl extends RemoteBaseRepository
    implements ProfileRepository {
  final bool addDelay;
  final ProfileSource _profileSource;

  ProfileRepositoryImpl(this._profileSource, {this.addDelay = true});

  // @override
  // Future<HouseResponse> getHouseTypeData() async {
  //   return getDataOf(
  //     request: () => _profileSource.getHouseType(APIConstants.contentType),
  //   );
  // }
}
