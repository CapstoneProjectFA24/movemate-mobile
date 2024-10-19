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

  Future<void> submitBooking({
    required BuildContext context,
  }) async {
    state = const AsyncLoading();

    final bookingState = ref.read(bookingProvider);
    final bookingRequest = BookingRequest.fromBooking(bookingState);
    final bookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    // Print the booking request for debugging
    print('Booking Request: ${jsonEncode(bookingRequest.toMap())}');

    state = await AsyncValue.guard(
      () async {
        // print(" gọi tới post bookingRequest: $bookingRequest");
        //comment chỗ nãy để tránh gọi api
        final bookingResponse = await bookingRepository.postBookingservice(
          request: bookingRequest,
          accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        );
        // print('API Response Data: ${jsonEncode(bookingResponse.payload)}');

        // Get the booking ID from the response
        final id = bookingResponse.payload.id;

        // Call the new function to refresh data using the booking ID
        await refreshBookingData(id: id);

        // Store bookingResponse in the provider
        ref.read(bookingResponseProvider.notifier).state =
            bookingResponse.payload;

        // Clean up booking provider state
        ref.read(bookingProvider.notifier).reset();

        // Navigate to LoadingScreenRoute()
        // context.router.replaceAll([const LoadingScreenRoute()]);
      },
    );

    if (state.hasError) {
      if (kDebugMode) {
        print('Error: ${state.error}');
      }
      final statusCode = (state.error as DioException).onStatusDio();
      handleAPIError(
        statusCode: statusCode,
        stateError: state.error!,
        context: context,
      );
    } else {
      // Navigate to LoadingScreenRoute with the bookingId
      context.router.replaceAll([const LoadingScreenRoute()]);
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
