import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/status_code_type.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {}

  Future<ProfileEntity?> getProfileInfor(
    PagingModel request,
    BuildContext context,
  ) async {
    ProfileEntity? profileInfor;

    // state = const AsyncLoading();
    final profileRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await profileRepository.getProfileInfor(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      profileInfor = response.payload;
      // print("controller ${houses.length}");
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
          onCallBackGenerateToken: () async => await reGenerateToken(
            authRepository,
            context,
          ),
        );

        if (state.hasError) {
          await ref.read(signInControllerProvider.notifier).signOut(context);
        }

        if (statusCode != StatusCodeType.unauthentication.type) {}
      });
    }
    return null;
  }

  Future<ProfileEntity?> getProfileInforById(
    int id,
    BuildContext context,
  ) async {
    ProfileEntity? profileInfor;

    // state = const AsyncLoading();
    final profileRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await profileRepository.getProfileInforById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      profileInfor = response.payload;
      print("controller ${profileInfor?.email}");
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
          onCallBackGenerateToken: () async => await reGenerateToken(
            authRepository,
            context,
          ),
        );

        if (state.hasError) {
          await ref.read(signInControllerProvider.notifier).signOut(context);
        }

        if (statusCode != StatusCodeType.unauthentication.type) {}
      });
    }
    return profileInfor;
  }

//wallet

  Future<WalletEntity?> getWallet(
    // PagingModel? request,
    BuildContext context,
  ) async {
    WalletEntity? walletInfor;

    state = const AsyncLoading();
    final walletRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("check controller");
    state = await AsyncValue.guard(() async {
      final response = await walletRepository.getWallet(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        // request: request,
      );
      walletInfor = response.payload;
      print("controller response $walletInfor");
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
          onCallBackGenerateToken: () async => await reGenerateToken(
            authRepository,
            context,
          ),
        );

        if (state.hasError) {
          await ref.read(signInControllerProvider.notifier).signOut(context);
        }

        if (statusCode != StatusCodeType.unauthentication.type) {}
      });
    }

    print("controller return ${walletInfor?.balance}");
    return walletInfor;
  }
}
