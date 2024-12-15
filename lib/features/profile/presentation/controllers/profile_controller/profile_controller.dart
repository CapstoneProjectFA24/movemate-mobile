import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/data/models/queries/with_draw_queries.dart';
import 'package:movemate/features/profile/data/models/request/unlock_wallet_request.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/commons/widgets/snack_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/status_code_type.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils

part 'profile_controller.g.dart';

final refreshWallet = StateProvider.autoDispose<bool>(
  (ref) => true,
);

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

    state = const AsyncLoading();
    final profileRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("object checking profile controller $id");
    state = await AsyncValue.guard(() async {
      final response = await profileRepository.getProfileInforById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      profileInfor = response.payload;
      // print("controller ${profileInfor?.email}");
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
    // print("check controller");
    state = await AsyncValue.guard(() async {
      final response = await walletRepository.getWallet(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        // request: request,
      );
      walletInfor = response.payload;
      // print("controller response $walletInfor");

      final walletEntity = WalletEntity(
        balance: response.payload.balance,
        id: response.payload.id,
        userId: response.payload.userId,
        createdAt: response.payload.createdAt,
        updatedAt: response.payload.updatedAt,
        bankNumber: response.payload.bankNumber,
        bankName: response.payload.bankName,
        isLocked: response.payload.isLocked,
        expirdAt: response.payload.expirdAt,
        cardHolderName: response.payload.cardHolderName,
      );

      ref.read(walletProvider.notifier).update(
            (state) => walletEntity,
          );

      ref.read(walletProvider.notifier).update(
            (state) => ref.read(walletProvider),
          );
      // ref.read(refreshWallet.notifier).update(
      //       (state) => !ref.read(refreshWallet),
      //     );
      ref.read(refreshWallet.notifier).update(
            (state) => ref.read(refreshWallet),
          );
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

    // print("controller return ${walletInfor?.balance}");
    return walletInfor;
  }
//unlock Wallet

  Future<WalletEntity?> unlockWallet(
    UnlockWalletRequest request,
    BuildContext context,
  ) async {
    WalletEntity? walletInfor;

    state = const AsyncLoading();
    final walletRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("check controller");
    state = await AsyncValue.guard(() async {
      final response = await walletRepository.unlockWallet(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      walletInfor = response.payload;
      print("controller response $walletInfor");

      final walletEntity = WalletEntity(
        balance: response.payload.balance,
        id: response.payload.id,
        userId: response.payload.userId,
        createdAt: response.payload.createdAt,
        updatedAt: response.payload.updatedAt,
        bankNumber: response.payload.bankNumber,
        bankName: response.payload.bankName,
        isLocked: response.payload.isLocked,
        expirdAt: response.payload.expirdAt,
        cardHolderName: response.payload.cardHolderName,
      );

      ref.read(walletProvider.notifier).update(
            (state) => walletEntity,
          );
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

  Future<void> withDrawWallet({
    required BuildContext context,
    required WithDrawQueries request,
  }) async {
    WalletEntity? walletInfor;

    state = const AsyncLoading();
    final walletRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("go here 1 ${request.amount}");

    state = await AsyncValue.guard(() async {
      print("go here 2");

      final res = await walletRepository.withDrawWallet(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      if (res.statusCode == 200) {
        print("go here 3 rút tiền thành công");
      }

      // walletInfor = response;
      print("controller response $walletInfor");
      print("go here 4");

      final responseWallet = await walletRepository.getWallet(
        accessToken: APIConstants.prefixToken + user.tokens.accessToken,
        // request: request,
      );
      print("go here 5");
      final walletEntity = WalletEntity(
        balance: responseWallet.payload.balance,
        id: responseWallet.payload.id,
        userId: responseWallet.payload.userId,
        createdAt: responseWallet.payload.createdAt,
        updatedAt: responseWallet.payload.updatedAt,
        bankNumber: responseWallet.payload.bankNumber,
        bankName: responseWallet.payload.bankName,
        isLocked: responseWallet.payload.isLocked,
        expirdAt: responseWallet.payload.expirdAt,
        cardHolderName: responseWallet.payload.cardHolderName,
      );
      print("go here 6");
      ref.read(walletProvider.notifier).update(
            (state) => walletEntity,
          );
      showSnackBar(
        context: context,
        content: "Yêu cầu rút tiền thành công",
        icon: AssetsConstants.iconSuccess,
        backgroundColor: Colors.orange,
        textColor: AssetsConstants.whiteColor,
      );
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

        // if (state.hasError) {
        //   await ref.read(signInControllerProvider.notifier).signOut(context);
        // }

        if (statusCode != StatusCodeType.unauthentication.type) {}
      });
    }
  }
}
