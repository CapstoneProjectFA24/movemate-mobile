// services_fee_system_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/models/request/paging_model.dart';
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
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getFeeSystems(
        request: request,
      );

      feesSystemData = response.payload;
      // Update servicesFeeList in BookingNotifier
      ref.read(bookingProvider.notifier).updateServicesFeeList(feesSystemData);

      state = AsyncData(feesSystemData);
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
        );
      });
    }

    return feesSystemData;
  }
}
