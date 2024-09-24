import 'package:flutter/material.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// config
import 'package:movemate/configs/routes/app_router.dart';

// domain - data
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

part 'sign_up_controller.g.dart';

@riverpod
class SignUpController extends _$SignUpController {
  late final FirebaseAuth firebaseAuth;

  @override
  FutureOr<void> build() {
    firebaseAuth = FirebaseAuth.instance;
  }

  // done
  Future<void> signUp({
    required String email,
    required String name,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);

    final request = SignUpRequest(
      email: email,
      name: name,
      phone: phone,
      password: password,
    );

    state = await AsyncValue.guard(() async {
      final res = await authRepository.signUp(request: request);

      if (res.statusCode == 200) {
        showSnackBar(
          context: context,
          content: "Đăng ký thành công",
          icon: AssetsConstants.iconSuccess,
          backgroundColor: AssetsConstants.mainColor,
          textColor: AssetsConstants.whiteColor,
        );
      } else {
        throw Exception(
            APIConstants.errorTrans[res.message] ?? "Đăng ký thất bại");
      }
    });

    if (state.hasError) {
      final error = state.error!;
      if (error is DioException) {
        final statusCode = error.response?.statusCode ?? error.onStatusDio();
        final errorMessage =
            APIConstants.errorTrans[error.response?.data['message']] ??
                'Có lỗi xảy ra';

        handleAPIError(
          statusCode: statusCode,
          stateError: errorMessage,
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

  Future<void> signUpwithOTP({
    required String email,
    required String name,
    required String phone,
    required String password,
    required VerificationOTPType type,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();

    final request = SignUpRequest(
      email: email,
      name: name,
      phone: phone,
      password: password,
    );
    await SharedPreferencesUtils.setSignInRequestInfo(request, "sign-up");
    final formattedPhone = formatPhoneNumber(phone);
    await sendOTP(formattedPhone);

    context.router.push(OTPVerificationScreenRoute(
        phoneNumber: formattedPhone, verifyType: type));

    if (state.hasError) {
      final error = state.error!;
      if (error is DioException) {
        final statusCode = error.response?.statusCode ?? error.onStatusDio();
        final errorMessage =
            APIConstants.errorTrans[error.response?.data['message']] ??
                'Có lỗi xảy ra';

        handleAPIError(
          statusCode: statusCode,
          stateError: errorMessage,
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

  String formatPhoneNumber(String phone) {
    // Loại bỏ tất cả các ký tự không phải số
    String digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    // Nếu số điện thoại bắt đầu bằng '0', thay thế bằng mã quốc gia '+84'
    if (digitsOnly.startsWith('0')) {
      digitsOnly = '84${digitsOnly.substring(1)}';
    }

    // Nếu số điện thoại chưa có dấu '+', thêm vào
    if (!digitsOnly.startsWith('+')) {
      digitsOnly = '+$digitsOnly';
    }

    return digitsOnly;
  }

  Future<void> sendOTP(String phone) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception('Gửi OTP thất bại ${e.message}');
      },
      codeSent: (String verificationId, int? resentToken) async {
        await SharedPreferencesUtils.setVerificationId(
            verificationId, 'verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Xử lý timeout nếu cần
      },
    );
  }
}
