// service_package_controller.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_valuation_request.dart';
import 'package:movemate/features/booking/data/models/resquest/valuation_price_one_of_system_service_request.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/truck_entity_response.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/extensions/status_code_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'house_type_controller.g.dart';

@riverpod
class HouseTypeController extends _$HouseTypeController {
  BookingResponseEntity? bookingResponseEntity;
  @override
  FutureOr<void> build() {}

//get house type by id
  Future<HouseTypeEntity?> getHouseTypeOldById(
    int id,
    BuildContext context,
  ) async {
    HouseTypeEntity? houseType;

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    // print("fcm token : ${user?.fcmToken}");
    print('vinh log house type old 1');
    print('vinh log house type old 1 $id');
    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypeById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );

      houseType = response.payload;
      print('vinh log house type old 2 ${houseType?.name.toString()}');
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
        await getHouseTypeOldById(id, context);
      });
    }

    return houseType;
  }
}
