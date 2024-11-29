// local
import 'package:movemate/data/models/response/profile_response/profile_response.dart';
import 'package:movemate/data/models/response/profile_response/staff_profile_response.dart';
import 'package:movemate/data/models/response/profile_response/wallet_response.dart';
import 'package:movemate/data/remote/profile_remote/profile_source.dart';

// system
import 'package:movemate/data/repositories/profile_repositories/profile_repository_impl.dart';
import 'package:movemate/data/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

abstract class ProfileRepository {
  // Future<HouseResponse> getHouseTypeData();
  Future<ProfileResponse> getProfileInfor({
    required PagingModel request,
    required String accessToken,
  });

  // House Type Methods get by id
  Future<ProfileResponse> getProfileInforById({
    required String accessToken,
    required int id,
  });
  Future<StaffProfileResponse> getProfileDriverInforById({
    required String accessToken,
    required int id,
  });

  //wallet
  Future<WalletResponse> getWallet({
    //  PagingModel request,
    required String accessToken,
  });
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final profileSource = ref.read(profileSourceProvider);
  return ProfileRepositoryImpl(profileSource);
}
