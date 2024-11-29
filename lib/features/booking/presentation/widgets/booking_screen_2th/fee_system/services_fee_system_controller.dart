// services_fee_system_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/domain/repositories/auth_repositories/auth_repository.dart';
import 'package:movemate/controllers/auth_controllers/sign_in_controller/sign_in_controller.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/data/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'services_fee_system_controller.g.dart';

@riverpod
class ServicesFeeSystemController extends _$ServicesFeeSystemController {
  @override
  FutureOr<void> build() {}

  Future<List<ServicesFeeSystemEntity>> getFeeSystems(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServicesFeeSystemEntity> feesSystemData = [];

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getFeeSystems(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );

      feesSystemData = response.payload;

      // Remove this line to prevent populating bookingState.servicesFeeList
      // ref.read(bookingProvider.notifier).updateServicesFeeList(feesSystemData);  

      state = AsyncData(feesSystemData);
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

        await getFeeSystems(request, context);
      });
    }
    return feesSystemData;
  }
}
