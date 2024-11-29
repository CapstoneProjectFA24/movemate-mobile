// config
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //import 'package:flutter_riverpod/flutter_riverpod
import 'package:hooks_riverpod/hooks_riverpod.dart'; //import  'package:hooks_riverpod/hooks_riverpod
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/domain/repositories/auth_repositories/auth_repository.dart';
import 'package:movemate/controllers/auth_controllers/sign_in_controller/sign_in_controller.dart';
import 'package:movemate/utils/commons/widgets/snack_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
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

final refreshWallet = StateProvider.autoDispose<bool>(
  (ref) => true,
);

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
    final authRepository = ref.read(authRepositoryProvider);

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
      state = await AsyncValue.guard(
        () async {
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

          // if refresh token expired
          // if (state.hasError) {
          //   await ref.read(signInControllerProvider.notifier).signOut(context);
          //   return;
          // }

          if (statusCode != StatusCodeType.unauthentication.type) {
            return;
          }

          await createPaymentBooking(
              context: context,
              selectedMethod: selectedMethod,
              bookingId: bookingId);
        },
      );
    }
  }

  Future<void> createLastPaymentBooking({
    required BuildContext context,
    required String selectedMethod,
    required String bookingId,
  }) async {
    state = const AsyncLoading();
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    final authRepository = ref.read(authRepositoryProvider);

    final request = PaymentRequest(
      bookingId: bookingId,
      selectedMethod: selectedMethod,
    );

    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentBooking(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      // print("createPaymentBooking: ${res.payload}");
      await launchUrl(Uri.parse(res.payload),
          mode: LaunchMode.externalApplication);
    });

    if (state.hasError) {
      state = await AsyncValue.guard(
        () async {
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

          // if refresh token expired
          // if (state.hasError) {
          //   await ref.read(signInControllerProvider.notifier).signOut(context);
          //   return;
          // }

          if (statusCode != StatusCodeType.unauthentication.type) {
            return;
          }

          await createPaymentBooking(
              context: context,
              selectedMethod: selectedMethod,
              bookingId: bookingId);
        },
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
    final authRepository = ref.read(authRepositoryProvider);

    final request = PaymentRequest(
      amount: amount,
      selectedMethod: selectedMethod,
    );
    print("check request for payment ${request.toString()}");
    state = await AsyncValue.guard(() async {
      final res = await paymentRepository.createPaymentDeposit(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );

      await launchUrl(Uri.parse(res.payload),
          mode: LaunchMode.externalApplication);
      ref
          .read(refreshWallet.notifier)
          .update((state) => !ref.read(refreshWallet));
    });
    print("object check request for payment ${state.hasValue.toString()}");
    if (state.hasError) {
      state = await AsyncValue.guard(
        () async {
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

          // if refresh token expired
          if (state.hasError) {
            await ref.read(signInControllerProvider.notifier).signOut(context);
            return;
          }

          if (statusCode != StatusCodeType.unauthentication.type) {
            return;
          }

          await createPaymentDeposit(
              context: context, selectedMethod: selectedMethod, amount: amount);
        },
      );
    }
  }

  Future<void> createPaymentBookingByWallet({
    required BuildContext context,
    required String selectedMethod,
    required int bookingId,
  }) async {
    state = const AsyncLoading();
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    final request = PaymentRequest(
      bookingId: bookingId.toString(),
      selectedMethod: selectedMethod,
    );

    state = await AsyncValue.guard(() async {
      await paymentRepository.createPaymentBooking(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
    });

    if (!state.hasError) {
      await context.router.push(TransactionResultScreenByWalletRoute(
        bookingId: bookingId,
      ));
    }

    if (state.hasError) {
      final error = state.error!;
      if (error is DioException) {
        final statusCode = error.response?.statusCode ?? error.onStatusDio();

        handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          content: error.toString(),
          icon: AssetsConstants.iconError,
          backgroundColor: Colors.red,
          textColor: AssetsConstants.whiteColor,
        );
      }
    }
  }

  Future<void> createLastPaymentBookingByWallet({
    required BuildContext context,
    required String selectedMethod,
    required int bookingId,
  }) async {
    state = const AsyncLoading();
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    final authRepository = ref.read(authRepositoryProvider);

    final request = PaymentRequest(
      bookingId: bookingId.toString(),
      selectedMethod: selectedMethod,
    );
    state = await AsyncValue.guard(() async {
      await paymentRepository.createPaymentBooking(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
    });

    if (!state.hasError) {
      await context.router.push(LastTransactionResultScreenByWalletRoute(
        bookingId: bookingId,
      ));
    }

    if (state.hasError) {
      final error = state.error!;
      if (error is DioException) {
        final statusCode = error.response?.statusCode ?? error.onStatusDio();

        handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          content: error.toString(),
          icon: AssetsConstants.iconError,
          backgroundColor: Colors.red,
          textColor: AssetsConstants.whiteColor,
        );
      }
    }
  }
}
