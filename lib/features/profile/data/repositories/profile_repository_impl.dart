// import local
import 'package:movemate/features/profile/data/models/queries/incident_queries.dart';
import 'package:movemate/features/profile/data/models/queries/transaction_queries.dart';
import 'package:movemate/features/profile/data/models/request/unlock_wallet_request.dart';
import 'package:movemate/features/profile/data/models/response/incident_response.dart';
import 'package:movemate/features/profile/data/models/response/profile_response.dart';
import 'package:movemate/features/profile/data/models/response/staff_profile_response.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/data/models/response/wallet_response.dart';
import 'package:movemate/features/profile/data/remote/profile_source.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
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
    // print("check repo");
    return getDataOf(
      request: () => _profileSource.getWallet(
        APIConstants.contentType,
        accessToken,
      ),
    );
  }

//unlock wallet
  @override
  Future<WalletResponse> unlockWallet({
    required String accessToken,
    required UnlockWalletRequest request,
  }) async {
    print("check repo");
    final requestUnlock = UnlockWalletRequest(
      bankName: request.bankName,
      bankNumber: request.bankNumber,
      cardHolderName: request.cardHolderName,
      expirdAt: request.expirdAt,
    );

    return getDataOf(
      request: () => _profileSource.unlockWallet(
        APIConstants.contentType,
        accessToken,
        requestUnlock,
      ),
    );
  }

  //transaction
  @override
  Future<TransactionResponse> getTransactionByUserId({
    PagingModel? request,
    required String accessToken,
    required int userId,
  }) async {
    final transactionQueries = TransactionQueries(
      userId: userId,
    ).toMap();
    print(' transactionQueries  ${transactionQueries.toString()}');

    return getDataOf(
      request: () => _profileSource.getTransactionByUserId(
        APIConstants.contentType,
        accessToken,
        transactionQueries,
      ),
    );
  }

  //transaction
  @override
  Future<TransactionResponse> getTransactionByUserIdWithWallet({
    PagingModel? request,
    required String accessToken,
    required int userId,
  }) async {
    final transactionQueries = TransactionQueries(
      isWallet: true,
      userId: userId,
    ).toMap();
    print(' transactionQueries  ${transactionQueries.toString()}');

    return getDataOf(
      request: () => _profileSource.getTransactionByUserId(
        APIConstants.contentType,
        accessToken,
        transactionQueries,
      ),
    );
  }

  //get list incident list
  @override
  Future<IncidentResponse> getIncidentListByUserId({
    PagingModel? request,
    required String accessToken,
    required int userId,
  }) async {
    final incidentQueries = IncidentQueries(
      userId: userId,
    ).toMap();

    return getDataOf(
      request: () => _profileSource.getIncidentListByUserId(
        APIConstants.contentType,
        accessToken,
        incidentQueries,
      ),
    );
  }
}
