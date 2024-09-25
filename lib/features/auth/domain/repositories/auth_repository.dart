import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl
import 'package:movemate/features/auth/data/remote/auth_source.dart';
import 'package:movemate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movemate/features/auth/data/models/request/sign_up_request/sign_up_request.dart';
import 'package:movemate/features/auth/data/models/request/response/account_response.dart';
import 'package:movemate/features/auth/data/models/request/sign_in_request.dart';

// model system
import 'package:movemate/models/response/success_model.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<SuccessModel> signUp({required SignUpRequest request});

  Future<AccountReponse> signIn({required SignInRequest request});
}

@Riverpod(keepAlive: false)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authSource = ref.read(authSourceProvider);
  return AuthRepositoryImpl(authSource);
}
