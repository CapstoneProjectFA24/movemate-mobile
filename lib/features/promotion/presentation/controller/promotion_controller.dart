import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_object_response.dart';
import 'package:movemate/features/promotion/data/models/response/voucher_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';

import 'package:movemate/features/promotion/domain/repositories/promotion_repository.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// domain - data
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'promotion_controller.g.dart';

final refreshPromotion = StateProvider.autoDispose<bool>(
  (ref) => true,
);

@riverpod
class PromotionController extends _$PromotionController {
  @override
  FutureOr<void> build() {}

  Future<List<PromotionEntity>> getPromotions(
    PagingModel request,
    BuildContext context,
  ) async {
    List<PromotionEntity> promotions = [];

    // state = const AsyncLoading();
    final promotionRepository = ref.read(promotionRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await promotionRepository.getPromotions(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        // userId: user.id!,
      );
      promotions = response.payload;
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

        await getPromotions(request, context);
      });
    }

    return promotions;
  }

  Future<PromotionAboutUserEntity?> getPromotionNoUser(
    BuildContext context,
  ) async {
    PromotionAboutUserEntity? promotionAboutUser;
    state = const AsyncLoading();
    final promotionRepository = ref.read(promotionRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("tuan checking controller 1");
    final result = await AsyncValue.guard(() async {
      final response = await promotionRepository.getPromotionNoUser(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );
      print("tuan checking controller 2  ${response.payload}");

      return response.payload;
    });
    print("tuan checking controller 3 $result");

    state = result;

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

        await getPromotionNoUser(context);
      });
    }
    if (result is AsyncData<PromotionAboutUserEntity>) {
      return result.value;
    } else {
      print("bị null ở controller checking");
      return null;
    } // Trả về đối tượng đầy đủ
  }

  Future<void> postVouherForUser(BuildContext context, int id,
      {int retryCount = 0}) async {
    const maxRetries = 3;

    state = const AsyncLoading();
    final promotionRepository = ref.read(promotionRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("object checking 1");

    state = await AsyncValue.guard(() async {
      print("object checking 2 $id");

      await promotionRepository.postVouherForUser(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      ref
          .read(refreshPromotion.notifier)
          .update((state) => !ref.read(refreshPromotion));
    });

    if (state.hasError) {
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

      // Retry logic with a limit on retries
      if (statusCode == StatusCodeType.unauthentication.type &&
          retryCount < maxRetries) {
        // Retry after a delay to prevent hammering the server too quickly
        await Future.delayed(const Duration(seconds: 2));
        return await postVouherForUser(context, id, retryCount: retryCount + 1);
      }
    }
  }
}
