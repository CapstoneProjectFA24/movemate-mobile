import 'package:flutter/material.dart';


import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';

// config
import 'package:movemate/configs/routes/app_router.dart';

// domain - data
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/constants/api_constant.dart';

part 'order_controller.g.dart';

@riverpod
class OrderController extends _$OrderController {
  @override
  FutureOr<void> build() {}

  Future<List<OrderEntity>> getBookings(
    PagingModel request,
    BuildContext context,
  ) async {
    List<OrderEntity> orders = [];

    state = const AsyncLoading();
    final orderRepository = ref.read(orderRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await orderRepository.getBookings(
          // accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
          // request: request,
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

    return orders;
  }
}
