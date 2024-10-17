// house_type_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'house_type_controller.g.dart';

@riverpod
class HouseTypeController extends _$HouseTypeController {
  @override
  FutureOr<void> build() {}

  Future<List<HouseTypeEntity>> getHouseTypes(
    PagingModel request,
    BuildContext context,
  ) async {
    List<HouseTypeEntity> houseTypeData = [];
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypes(
        request: request,
      );
      print("HouseTypeEntity: $response");
      houseTypeData = response.payload;
      state = AsyncData(houseTypeData);
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
    print("HouseTypeEntity: $houseTypeData");
    return houseTypeData;
  }
}
