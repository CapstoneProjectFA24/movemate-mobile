import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/data/models/response/transaction_response.dart';
import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';
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

part 'incident_controller.g.dart';

@riverpod
class IncidentController extends _$IncidentController {
  @override
  FutureOr<void> build() {}

  Future<List<BookingTrackersIncidentEntity>> getIncidentListByUserId(
    PagingModel request,
    BuildContext context,
  ) async {
    List<BookingTrackersIncidentEntity> incidents = [];

    state = const AsyncLoading();
    final incidentRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await incidentRepository.getIncidentListByUserId(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        userId: user.id!,
      );
      incidents = response.payload;
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
        await getIncidentListByUserId(request, context);
      });
    }

    return incidents;
  }
}
