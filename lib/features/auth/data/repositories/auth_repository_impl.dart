// import local

import 'package:movemate/features/auth/data/models/response/account_response.dart';
import 'package:movemate/features/auth/data/models/request/sign_in_request.dart';

import '../../domain/repositories/auth_repository.dart';
import '../remote/auth_source.dart';
import '../models/request/sign_up_request.dart';
import 'package:movemate/features/auth/data/models/request/otp_verify_request.dart';

// models system
import 'package:movemate/models/response/success_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class AuthRepositoryImpl extends RemoteBaseRepository
    implements AuthRepository {
  final bool addDelay;
  final AuthSource _authSource;
  AuthRepositoryImpl(this._authSource, {this.addDelay = true});

  @override
  Future<SuccessModel> signUp({required SignUpRequest request}) {
    print("SignUpRequest as Map: ${request.toJson()}");

    return getDataOf(
      request: () => _authSource.signUp(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> checkValidUser({required SignUpRequest request}) {
    return getDataOf(
      request: () =>
          _authSource.checkValidUser(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> verifyToken({required OTPVerifyRequest request}) {
    return getDataOf(
      request: () => _authSource.verifyToken(request, APIConstants.contentType),
    );
  }

  @override
  Future<AccountReponse> signUpAndRes({required SignUpRequest request}) async {
    return getDataOf(
      request: () =>
          _authSource.signUpAndRes(request, APIConstants.contentType),
    );
  }

  @override
  Future<AccountReponse> signIn({required SignInRequest request}) {
    return getDataOf(
      request: () => _authSource.signIn(request, APIConstants.contentType),
    );
  }
}
