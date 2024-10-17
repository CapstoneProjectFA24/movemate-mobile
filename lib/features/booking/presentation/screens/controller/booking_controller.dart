import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
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

@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<void> build() {}

  Future<void> submitBooking({
    required BuildContext context,
  }) async {
    state = const AsyncLoading();

    final bookingState = ref.read(bookingProvider);
    final bookingRequest = BookingRequest.fromBooking(bookingState);
    final bookingRepository = ref.read(serviceBookingRepositoryProvider);

    // Print the booking request for debugging
    print('Booking Request: ${jsonEncode(bookingRequest.toMap())}');

    state = await AsyncValue.guard(
      () async {
        //comment chỗ nãy để tránh gọi api
        await bookingRepository.postBookingservice(request: bookingRequest);

        // Clean up booking provider state
        ref.read(bookingProvider.notifier).reset();

        // Navigate to LoadingScreenRoute()
        context.router.replaceAll([const LoadingScreenRoute()]);
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
    }
  }
}
