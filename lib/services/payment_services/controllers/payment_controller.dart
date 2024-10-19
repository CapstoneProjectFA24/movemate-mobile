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

    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentBooking(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      print("createPaymentBooking: ${res.payload}");
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

    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentDeposit(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
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
