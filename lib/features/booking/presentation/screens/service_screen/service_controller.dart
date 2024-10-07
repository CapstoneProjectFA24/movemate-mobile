// domain - data
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_repository.dart';

//system
import 'package:flutter/material.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// utils
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'service_controller.g.dart';

@riverpod
class ServiceController extends _$ServiceController {
  @override
  FutureOr<void> build() {}

  Future<List<ServiceEntity>> getServices(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServiceEntity> serviceCateData = [];

    state = const AsyncLoading();
    final serviceRepository = ref.read(serviceRepositoryProvider);
    // final authRepository = ref.read(authRepositoryProvider);
    // final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceRepository.getServices(
        // accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      serviceCateData = response.payload as List<ServiceEntity>;
      state = AsyncData(serviceCateData);
      print(" call in res $serviceCateData");

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

    print(" call from controller $serviceCateData");

    return serviceCateData;
  }
}
