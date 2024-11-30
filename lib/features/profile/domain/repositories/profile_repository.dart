// local
import 'package:movemate/features/profile/data/models/queries/transations_queries.dart';
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/models/response/staff_profile_response.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/data/models/response/wallet_response.dart';
import 'package:movemate/features/profile/data/remote/profile_source.dart';

// system
import 'package:movemate/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
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
  //getTransaction
  Future<TransactionResponse> getTransaction({
    required TransationsQueries queries,
    required String accessToken,
  });
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final profileSource = ref.read(profileSourceProvider);
  return ProfileRepositoryImpl(profileSource);
}
