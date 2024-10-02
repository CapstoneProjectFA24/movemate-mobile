import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/booking_entities.dart';
import 'package:movemate/features/booking/domain/repositories/booking_repository.dart';

import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// config

// domain - data

import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'booking_controller.g.dart';

@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<List<BookingEntities>> build() {
    return const [];
  }

  Future<List<BookingEntities>> getBookings(BuildContext context) async {
    List<BookingEntities> dataListNameHere = [];

    state = const AsyncLoading();
    final bookingRepository = ref.read(bookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await bookingRepository.getBookingData(
          // accessToken: APIConstants.prefixToken + user!.token.accessToken,
          );
      dataListNameHere = response.payload;
      return dataListNameHere;
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

        return await getBookings(context);
      });
    }

    return dataListNameHere;
  }
}
