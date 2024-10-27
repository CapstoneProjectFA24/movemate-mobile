import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:movemate/features/booking/data/models/resquest/booking_request.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:auto_route/auto_route.dart';
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
      print('Booking bookingResponse: ${jsonEncode(bookingResponse.toMap())}');

      final id = bookingResponse.payload.id;

      // Refresh booking data
      await refreshBookingData(id: id);

      // Store bookingResponse in the provider
      ref.read(bookingResponseProvider.notifier).state =
          bookingResponse.payload;

      // Reset booking provider state
      // ref.read(bookingProvider.notifier).reset();
      print("booking Response: ${jsonEncode(bookingResponse.payload)}");
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

  Future<OrderEntity?> getOrderEntityById(int id) async {
    final bookingRepository = ref.read(serviceBookingRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    try {
      final bookingResponse = await bookingRepository.getBookingDetails(
        id: id,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );

      // Cập nhật bookingResponseProvider
      ref.read(bookingResponseProvider.notifier).state =
          bookingResponse.payload;

      // Chuyển đổi BookingResponseEntity thành OrderEntity
      final orderEntity =
          OrderEntity.fromBookingResponse(bookingResponse.payload);

      return orderEntity;
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching booking details: $e');
      return null;
    }
  }

  Future<void> confirmReviewBooking({
    required ReviewerStatusRequest request,
    required int id,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      await ref.read(serviceBookingRepositoryProvider).confirmReviewBooking(
            accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
            request: request,
            id: id,
          );

      // stream realtime -> ref status
      // case1
      // todo nếu mà status là WAITING + not online -> chọn truyền status DEPOSITING -> sau đó chuyển qua paymenscrent

      // case 2 online
      if (request.status.type == BookingStatusType.depositing) {
        context.router.push(PaymentScreenRoute(id: id));
      }

      // TO DO MORE
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
    }
  }
}
