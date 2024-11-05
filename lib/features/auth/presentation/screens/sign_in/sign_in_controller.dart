import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/functions/firebase_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/models/user_model.dart';

import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/data/models/request/sign_in_request.dart';

import 'package:movemate/utils/enums/enums_export.dart';
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

        // get FCM token
        final deviceToken = await getDeviceToken();
        print(" token fcm : $deviceToken");
        final userModel = UserModel(
          id: user.payload.id,
          email: user.payload.email,
          tokens: user.payload.tokens,
        );

        ref.read(authProvider.notifier).update(
              (state) => userModel,
            );
        await SharedPreferencesUtils.setInstance(
          userModel,
          'user_token',
        );
        context.router.replaceAll([const TabViewScreenRoute()]);
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

  Future<void> signOut(
    BuildContext context,
  ) async {
    state = const AsyncLoading();

    ref.read(modifyProfiver.notifier).update((state) => true);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(
      () async {
        // final userDevice = user!.userTokens!.firstWhere(
        //   (element) => element.fcmToken == user.fcmToken,
        // );

        ref.read(authProvider.notifier).update((state) => null);
        await authRepository.signOut();
        // await authRepository.deleteToken(
        //   id: userDevice.userDeviceId!,
        // );

        ref.read(modifyProfiver.notifier).update((state) => false);
        context.router.replaceAll([SignInScreenRoute()]);
      },
    );

    // access expired || other error
    if (state.hasError) {
      state = await AsyncValue.guard(
        () async {
          final statusCode = (state.error as DioException).onStatusDio();
          await handleAPIError(
            statusCode: statusCode,
            stateError: state.error!,
            context: context,
            onCallBackGenerateToken: () => reGenerateToken(
              authRepository,
              context,
            ),
          );

          // if refresh token expired
          if (state.hasError) {
            ref.read(modifyProfiver.notifier).update((state) => false);
            showExceptionAlertDialog(
              context: context,
              title: 'Thông báo',
              exception: 'Có lỗi rồi không thể đăng xuất.',
            );
            return;
          }

          if (statusCode != StatusCodeType.unauthentication.type) {
            return;
          }

          await signOut(context);
        },
      );
    }
  }
}
