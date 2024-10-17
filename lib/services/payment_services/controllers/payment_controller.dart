// config
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movemate/utils/extensions/status_code_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// domain - data
import 'package:movemate/services/payment_services/domain/repositories/payment_repository.dart';
import 'package:movemate/services/payment_services/data/models/request/payment_request.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/commons/functions/functions_common_export.dart';
import 'package:url_launcher/url_launcher.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  FutureOr<void> build() {}

  Future<void> createPaymentBooking({
    required BuildContext context,
    required String selectedMethod,
    required String bookingId,
  }) async {
    state = const AsyncLoading();
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final request = PaymentRequest(
      bookingId: bookingId,
      selectedMethod: selectedMethod,
    );

    // fake
    final accessToken =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwiZW1haWwiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwic2lkIjoiMSIsInJvbGUiOiIxIiwianRpIjoiMDQ2ZjQ5OTAtNGU4MS00ZDQ4LWE4OGUtMzI0ZDFjZjNlNzljIiwibmJmIjoxNzI5MTQzMzg4LCJleHAiOjIzMjkxNDMzODgsImlhdCI6MTcyOTE0MzM4OH0.SeJB2TimmQImxMrnyS0BNCYhnkQn5aYHTqHxLwHDFt06GOXijkZaKAlmGozEln9VFYoPcuVfdntK_0h2UeGE5w";

    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentBooking(
        // accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        accessToken:APIConstants.prefixToken + accessToken,
        request: request,
      );

      await launchUrl(Uri.parse(res.payload),
          mode: LaunchMode.externalApplication);
    });
    if (state.hasError) {
      if (kDebugMode) {
        print(state.error);
      }
      final statusCode = (state.error as DioException).onStatusDio();
      handleAPIError(
        statusCode: statusCode,
        stateError: state.error!,
        context: context,
      );
    }
  }

  Future<void> createPaymentDeposit({
    required BuildContext context,
    required String selectedMethod,
    required double amount,
  }) async {
    state = const AsyncLoading();
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final request = PaymentRequest(
      amount: amount,
      selectedMethod: selectedMethod,
    );

    // fake
    final accessToken =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwiZW1haWwiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwic2lkIjoiMSIsInJvbGUiOiIxIiwianRpIjoiMDQ2ZjQ5OTAtNGU4MS00ZDQ4LWE4OGUtMzI0ZDFjZjNlNzljIiwibmJmIjoxNzI5MTQzMzg4LCJleHAiOjIzMjkxNDMzODgsImlhdCI6MTcyOTE0MzM4OH0.SeJB2TimmQImxMrnyS0BNCYhnkQn5aYHTqHxLwHDFt06GOXijkZaKAlmGozEln9VFYoPcuVfdntK_0h2UeGE5w";

    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentDeposit(
        // accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        accessToken:APIConstants.prefixToken + accessToken,
        request: request,
      );

      await launchUrl(Uri.parse(res.payload),
          mode: LaunchMode.externalApplication);
    });
    if (state.hasError) {
      if (kDebugMode) {
        print(state.error);
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
