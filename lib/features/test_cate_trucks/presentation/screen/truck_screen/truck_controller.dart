// domain - data
import 'package:movemate/features/test_cate_trucks/domain/entities/truck_entities.dart';

//system
import 'package:flutter/material.dart';
import 'package:movemate/features/test_cate_trucks/domain/repositories/truck_repository.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// utils
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'truck_controller.g.dart';

@riverpod
class TruckController extends _$TruckController {
  @override
  FutureOr<void> build() {}

  Future<List<TruckEntities>> getTrucks(
    PagingModel request,
    BuildContext context,
  ) async {
    List<TruckEntities> truckCateData = [];

    state = const AsyncLoading();
    final truckRepository = ref.read(truckRepositoryProvider);
    // final authRepository = ref.read(authRepositoryProvider);
    // final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await truckRepository.getTrucks(
        // accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      truckCateData = response.payload;
      state = AsyncData(truckCateData);
      print(" call in res $truckCateData");
      print(" call in res $state");
      // return truckCateData;
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

    print(" call from controller $truckCateData");

    return truckCateData;
  }
}
