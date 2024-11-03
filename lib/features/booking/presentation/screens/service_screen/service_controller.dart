// service_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/services_package_truck_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/extensions/status_code_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getServices(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );

      serviceCateData = response.payload;
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

        await getServices(request, context);
      });
    }
    return serviceCateData;
  }

  // Truck services
  Future<List<ServicesPackageTruckEntity>> getServicesTruck(
    PagingModel request,
    BuildContext context,
  ) async {
    final servicesPackageRepository =
        ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    try {
      final response = await servicesPackageRepository.getServicesTruck(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      for (var service in response.payload) {
        print(" response Service: ${service.toString()}");
      }

      // Return the data directly
      return response.payload;
    } catch (error) {
      final statusCode = (error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: error,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode == StatusCodeType.unauthentication.type) {
        await ref.read(signInControllerProvider.notifier).signOut(context);
      } else {
        // Retry the request if not unauthenticated
        return await getServicesTruck(request, context);
      }
      // Return empty list if error persists
      return [];
    }
  }
}
