// local
import 'package:movemate/features/profile/data/models/queries/with_draw_queries.dart';
import 'package:movemate/features/profile/data/models/request/unlock_wallet_request.dart';
import 'package:movemate/features/profile/data/models/response/incident_response.dart';
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/models/response/staff_profile_response.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/data/models/response/wallet_response.dart';
import 'package:movemate/features/profile/data/remote/profile_source.dart';

// system
import 'package:movemate/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
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

  // unlock Wallet
  Future<WalletResponse> unlockWallet({
    required String accessToken,
    required UnlockWalletRequest request,
  });

  // with draw wallet
  Future<SuccessModel> withDrawWallet({
    required String accessToken,
    required WithDrawQueries request,
  });

  //transaction
  Future<TransactionResponse> getTransactionByUserId({
    PagingModel request,
    required String accessToken,
    required int userId,
  });
  //transaction
  Future<TransactionResponse> getTransactionByUserIdWithWallet({
    PagingModel request,
    required String accessToken,
    required int userId,
  });
  //get  incident list
  Future<IncidentResponse> getIncidentListByUserId({
    PagingModel request,
    required String accessToken,
    required int userId,
  });
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final profileSource = ref.read(profileSourceProvider);
  return ProfileRepositoryImpl(profileSource);
}
