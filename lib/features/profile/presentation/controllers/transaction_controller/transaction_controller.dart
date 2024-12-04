import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';

import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/status_code_type.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/providers/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils

part 'transaction_controller.g.dart';

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<void> build() {}

//transaction

  Future<List<TransactionEntity>> getTransactionByUserId(
    PagingModel request,
    BuildContext context,
  ) async {
    List<TransactionEntity> transactions = [];

    state = const AsyncLoading();
    final transactionRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    print("check controller");
    print("check controller request ${request.userId}");

    state = await AsyncValue.guard(() async {
      final response = await transactionRepository.getTransactionByUserId(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        // request: PagingModel(userId: user.id),
        userId: user.id!,
      );
      transactions = response.payload;
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
        await getTransactionByUserId(request, context);
      });
    }

    return transactions;
  }
// transaction by wallet
  Future<List<TransactionEntity>> getTransactionByUserIdWithWallet(
    PagingModel request,
    BuildContext context,
  ) async {
    List<TransactionEntity> transactions = [];

    state = const AsyncLoading();
    final transactionRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    print("check controller");
    print("check controller request ${request.userId}");

    state = await AsyncValue.guard(() async {
      final response = await transactionRepository.getTransactionByUserIdWithWallet(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        // request: PagingModel(userId: user.id),
        userId: user.id!,
      );
      transactions = response.payload;
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
        await getTransactionByUserIdWithWallet(request, context);
      });
    }

    return transactions;
  }

}
