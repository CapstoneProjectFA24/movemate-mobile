import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// domain - data
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'sign_up_controller.g.dart';

@riverpod
class SignUpController extends _$SignUpController {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({
    required String email,
    required String name,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);

    final request = SignUpRequest(
      email: email,
      name: name,
      phone: phone,
      password: password,
    );

    state = await AsyncValue.guard(
      () async {
        await authRepository.signUp(request: request);

        print("api working");
        showSnackBar(
          context: context,
          content: "Đăng kí thành công",
          icon: AssetsConstants.iconSuccess,
          backgroundColor: AssetsConstants.mainColor,
          textColor: AssetsConstants.whiteColor,
        );
      },
    );

    if (state.hasError) {
      final statusCode = (state.error as DioException).onStatusDio();

      handleAPIError(
        statusCode: statusCode,
        stateError: state.error!,
        context: context,
      );
    }
  }
}
