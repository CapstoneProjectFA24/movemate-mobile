// import local
import '../../domain/repositories/auth_repository.dart';
import '../remote/auth_source.dart';
import '../models/request/sign_up_request.dart';

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
    print("SignUpRequest as Map: ${request.toMap()}");

    return getDataOf(
      request: () => _authSource.signUp(request, APIConstants.contentType),
    );
  }
}
