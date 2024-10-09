// domain - data
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/repositories/house_type_repository.dart';

//system
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// utils
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
    final houseTypeRepository = ref.read(houseTypeRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await houseTypeRepository.getHouseTypes(
        request: request,
      );

      houseTypeData = response.payload;
      state = AsyncData(houseTypeData);
      // return houseTypeData;
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

    return houseTypeData;
  }
}
