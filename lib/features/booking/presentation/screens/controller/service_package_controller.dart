// service_package_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_request.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/extensions/status_code_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_package_controller.g.dart';

@riverpod
class ServicePackageController extends _$ServicePackageController {
  BookingResponseEntity? bookingResponseEntity;
  @override
  FutureOr<void> build() {}

  Future<List<ServicesPackageEntity>> servicePackage(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServicesPackageEntity> servicePackages = [];

    state = const AsyncLoading();
    final servicesPackageRepository =
        ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await servicesPackageRepository.getPackageServices(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      servicePackages = response.payload;
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

        await servicePackage(request, context);
      });
    }
    return servicePackages;
  }

  Future<List<HouseTypeEntity>> getHouseTypes(
    PagingModel request,
    BuildContext context,
  ) async {
    List<HouseTypeEntity> houseTypeData = [];

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);

    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypes(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
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
          onCallBackGenerateToken: () async => await reGenerateToken(
            authRepository,
            context,
          ),
        );

        if (state.hasError) {
          await ref.read(signInControllerProvider.notifier).signOut(context);
        }

        if (statusCode != StatusCodeType.unauthentication.type) {}

        await getHouseTypes(request, context);
      });
    }

    return houseTypeData;
  }

  Future<HouseTypeEntity?> getHouseTypeById(
    int id,
    BuildContext context,
  ) async {
    HouseTypeEntity? houseType;

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypeById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );

      houseType = response.payload;
      print('vinh log ${houseType?.toJson()}');
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
        await getHouseTypeById(id, context);
      });
    }

    return houseType;
  }

  //----------------------------------------------------------------

  Future<BookingResponseEntity?> postValuationBooking({
    required BookingRequest bookingRequest,
    required BuildContext context,
  }) async {
    // Kiểm tra nếu đã đang xử lý thì không làm gì cả
    if (state is AsyncLoading) {
      return null;
    }
    // state = const AsyncLoading();

    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    BookingResponseEntity? responsePayload;

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.postValuationBooking(
        request: bookingRequest,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );
      // Không thiết lập lại state ở đây
      responsePayload = response.payload;
      // return responsePayload;
    });

    if (state.hasError) {
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
      return null;
    }

    return responsePayload;
  }
}
