import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/models/user_model.dart';

import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/data/models/request/sign_in_request.dart';

import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    String? email,
    String? phone,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);

    // Tạo request với email hoặc phone
    final request = SignInRequest(
      email: email,
      phone: phone,
      password: password,
    );

    state = await AsyncValue.guard(
      () async {
        final user = await authRepository.signIn(request: request);

        final userModel = UserModel(
          id: user.id,
          email: user.email,
          tokens: user.tokens,
        );

        ref.read(authProvider.notifier).update(
              (state) => userModel,
            );
        await SharedPreferencesUtils.setInstance(
          userModel,
          'user_token',
        );
        context.router.replaceAll([const HomeScreenRoute()]);
      },
    );

    if (state.hasError) {
      if (kDebugMode) {
        print(state.error);
      }
      final statusCode = (state.error as DioException).onStatusDio();
      handleAPIError(
        statusCode: statusCode,
        stateError: state.error!,
        context: context,
      );
    }
  }
}
