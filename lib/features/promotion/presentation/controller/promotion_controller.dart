import 'package:flutter/material.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';

import 'package:movemate/features/promotion/domain/repositories/promotion_repository.dart';

import 'package:movemate/models/request/paging_model.dart';
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




}
