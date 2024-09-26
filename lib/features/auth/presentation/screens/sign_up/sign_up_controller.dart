import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// domain - data
import 'package:movemate/features/auth/data/models/request/sign_up_request/sign_up_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/constants/api_constant.dart';

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

    state = await AsyncValue.guard(() async {
      final res = await authRepository.signUp(request: request);

      if (res.statusCode == 200) {
        showSnackBar(
          context: context,
          content: "Đăng ký thành công",
          icon: AssetsConstants.iconSuccess,
          backgroundColor: AssetsConstants.mainColor,
          textColor: AssetsConstants.whiteColor,
        );
      } else {
        throw Exception(
            APIConstants.errorTrans[res.message] ?? "Đăng ký thất bại");
      }
    });

    if (state.hasError) {
      final error = state.error!;
      if (error is DioException) {
        final statusCode = error.response?.statusCode ?? error.onStatusDio();
        final errorMessage =
            APIConstants.errorTrans[error.response?.data['message']] ??
                'Có lỗi xảy ra';

        handleAPIError(
          statusCode: statusCode,
          stateError: errorMessage,
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          content: error.toString(),
          icon: AssetsConstants.iconError,
          backgroundColor: Colors.red,
          textColor: AssetsConstants.whiteColor,
        );
      }
    }
  }
}
