import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/order/data/models/request/change_booking_at_request.dart';
import 'package:movemate/features/order/data/models/request/user_report_request.dart';
import 'package:movemate/features/order/domain/entites/truck_categories_entity.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// domain - data
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';

// utils
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'order_controller.g.dart';

final refreshOrderDetails = StateProvider.autoDispose<bool>(
  (ref) => true,
);

@riverpod
class OrderController extends _$OrderController {
  @override
  FutureOr<void> build() {}

  Future<List<OrderEntity>> getBookings(
    PagingModel request,
    BuildContext context,
  ) async {
    List<OrderEntity> orders = [];

    // state = const AsyncLoading();
    final orderRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await orderRepository.getBookings(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        userId: user.id!,
      );
      orders = response.payload;
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

        await getBookings(request, context);
      });
    }

    return orders;
  }

  Future<List<ServicesPackageEntity>> getAllService(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServicesPackageEntity> orders = [];

    // state = const AsyncLoading();
    final orderRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await orderRepository.getAllService(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
        // userId: user.id!,
      );
      orders = response.payload;
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

        await getBookings(request, context);
      });
    }

    return orders;
  }

// list truck
  Future<List<TruckCategoriesEntity>> getTruckList(
    PagingModel request,
    BuildContext context,
  ) async {
    List<TruckCategoriesEntity> TruckList = [];

    // state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.getTruckList(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      TruckList = response.payload;
      print("controller TruckList.length ${TruckList.length}");
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
      });
    }

    return TruckList;
  }

  Future<TruckCategoriesEntity?> getTruckById(
    int id,
    BuildContext context,
  ) async {
    TruckCategoriesEntity? truckCate;

    // state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final result = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.getTruckById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      // print("controller ${response.payload}");
      return response.payload;
    });

    state = result;

    if (result.hasError) {
      final statusCode = (result.error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: result.error!,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode != StatusCodeType.unauthentication.type) {}
    }

    if (result is AsyncData<TruckCategoriesEntity>) {
      return result.value;
    } else {
      return null;
    }
  }

  Future<OrderEntity?> getBookingNewById(
    int id,
    BuildContext context,
  ) async {
    OrderEntity? order;

    // state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final result = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.getBookingNewById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      // print("controller ${response.payload}");
      return response.payload;
    });

    state = result;

    if (result.hasError) {
      final statusCode = (result.error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: result.error!,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode != StatusCodeType.unauthentication.type) {}
    }

    if (result is AsyncData<OrderEntity>) {
      return result.value;
    } else {
      return null;
    }
  }

  Future<OrderEntity?> getBookingOldById(
    int id,
    BuildContext context,
  ) async {
    OrderEntity? order;

    // state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final result = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.getBookingOldById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      // print("controller ${response.payload}");
      return response.payload;
    });

    state = result;

    if (result.hasError) {
      final statusCode = (result.error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: result.error!,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode != StatusCodeType.unauthentication.type) {}
    }

    if (result is AsyncData<OrderEntity>) {
      return result.value;
    } else {
      return null;
    }
  }

  Future<void> changeBookingAt(
    ChangeBookingAtRequest request,
    BuildContext context,
    int id,
  ) async {
    state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    print("check date time controller1 ${request.toJson()}");
    final result = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.changeBookingAt(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      ref
          .read(refreshOrderDetails.notifier)
          .update((state) => !ref.read(refreshOrderDetails));

      print("check date time controller2 ${request.toJson()}");
      return response;
    });

    print("check date time controller3 ${request.toJson()}");
    state = result;

    if (result.hasError) {
      final statusCode = (result.error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: result.error!,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode != StatusCodeType.unauthentication.type) {}
    }
  }

  Future<void> postUserReport(
    UserReportRequest request,
    BuildContext context,
    int id,
  ) async {
    state = const AsyncLoading();
    final truckTypeRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    print("check date time controller1 ${request.toJson()}");
    print(
        "check date time controller 12 ${request.resourceList.first.toJson()}");

    final result = await AsyncValue.guard(() async {
      final response = await truckTypeRepository.postUserReport(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      ref
          .read(refreshOrderDetails.notifier)
          .update((state) => !ref.read(refreshOrderDetails));

      print("check date time controller2 ${request.toJson()}");
      return response;
    });

    print("check date time controller3 ${request.toJson()}");
    print("check date time controller3 ${result.value.toString()}");
    state = result;

    if (!result.hasError) {
      context.router.replaceAll([const IncidentsListScreenRoute()]);
    }
    if (result.hasError) {
      final statusCode = (result.error as DioException).onStatusDio();
      await handleAPIError(
        statusCode: statusCode,
        stateError: result.error!,
        context: context,
        onCallBackGenerateToken: () async => await reGenerateToken(
          authRepository,
          context,
        ),
      );

      if (statusCode != StatusCodeType.unauthentication.type) {}
    }
  }
}
