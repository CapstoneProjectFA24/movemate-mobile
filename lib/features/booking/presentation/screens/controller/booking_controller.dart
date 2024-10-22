import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_requesst.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'booking_controller.g.dart';

final bookingResponseProvider =
    StateProvider<BookingResponseEntity?>((ref) => null);

@riverpod
class BookingController extends _$BookingController {
  int? bookingId;
  @override
  FutureOr<void> build() {}

  Future<BookingResponseEntity?> submitBooking({
    required BuildContext context,
  }) async {
    // Kiểm tra nếu đã đang xử lý thì không làm gì cả
    if (state is AsyncLoading) {
      return null;
    }
    state = const AsyncLoading();
    final bookingState = ref.read(bookingProvider);
    final bookingRequest = BookingRequest.fromBooking(bookingState);
    final bookingRepository = ref.read(serviceBookingRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    // Debugging
    print('Booking Request: ${jsonEncode(bookingRequest.toMap())}');

    state = await AsyncValue.guard(() async {
      final bookingResponse = await bookingRepository.postBookingservice(
        request: bookingRequest,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );

      final id = bookingResponse.payload.id;

      // Refresh booking data
      await refreshBookingData(id: id);

      // Store bookingResponse in the provider
      ref.read(bookingResponseProvider.notifier).state =
          bookingResponse.payload;

      // Reset booking provider state
      // ref.read(bookingProvider.notifier).reset();
      print("bookingResponse: ${jsonEncode(bookingResponse.payload)}");
    });

    if (state.hasError) {
      if (kDebugMode) {
        print('Error: at controller ${state.error}');
      }
      final statusCode = (state.error as DioException).onStatusDio();
      handleAPIError(
        statusCode: statusCode,
        stateError: state.error!,
        context: context,
      );
      return null;
    } else {
      print('Booking success ${ref.read(bookingResponseProvider)}');
      return ref.read(bookingResponseProvider);
    }
    
  }

  Future<void> refreshBookingData({required int id}) async {
    final bookingRepository = ref.read(serviceBookingRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () async {
        final bookingResponse = await bookingRepository.getBookingDetails(
          id: id,
          accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        );
        // Update the bookingResponseProvider with updated booking
        ref.read(bookingResponseProvider.notifier).state =
            bookingResponse.payload;

        bookingId = bookingResponse.payload.id;
        print('Refreshed booking data: ${jsonEncode(bookingResponse.payload)}');
      },
    );

    if (result.hasError) {
      if (kDebugMode) {
        print('Error refreshing booking data: ${result.error}');
      }
      // Handle errors as needed
    }
  }
}
