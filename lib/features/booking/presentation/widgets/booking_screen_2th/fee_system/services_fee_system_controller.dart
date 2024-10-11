// domain - data


//system
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/domain/repositories/services_fee_system_repository.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// utils
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
    final ServicesFeeSystemRepository = ref.read(servicesFeeSystemRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await ServicesFeeSystemRepository.getFeeSystems(
        request: request,
      );

      feesSystemData = response.payload;
      // Cập nhật servicesFeeList trong BookingNotifier
      ref.read(bookingProvider.notifier).updateServicesFeeList(feesSystemData);

      state = AsyncData(feesSystemData);
      // return feesSystemData;
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
          // onCallBackGenerateToken: () async => await reGenerateToken(
          //   authRepository,
          //   context,
          // ),
        );

        // if (state.hasError) {
        //   await ref.read(signInControllerProvider.notifier).signOut(context);
        //   return [];
        // }

        // if (statusCode != StatusCodeType.unauthentication.type) {
        //   return [];
        // }

        // return await getHouses(context);
        // return [];
      });
    }

    return feesSystemData;
  }
}
