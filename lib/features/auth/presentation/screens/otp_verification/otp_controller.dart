import 'package:flutter/material.dart';
import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';
import 'package:movemate/models/user_model.dart';
import 'package:movemate/utils/providers/common_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

// config
import 'package:movemate/configs/routes/app_router.dart';

// domain - data
import 'package:movemate/features/auth/data/models/request/otp_verify_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/functions_common_export.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';

part 'otp_controller.g.dart';

class OtpController extends _$OtpController {
  late final FirebaseAuth firebaseAuth;
  static const int MAX_RETRIES = 3;
  static const int RETRY_DELAY_SECONDS = 2;

  @override
  FutureOr<void> build() {
    firebaseAuth = FirebaseAuth.instance;
  }

  Future<void> verifyOTP({
    required BuildContext context,
    required String otpSms,
  }) async {
    state = const AsyncLoading();

    final verificationId =
        await SharedPreferencesUtils.getVerificationId("verificationId");

    if (verificationId == null) {
      showError(
          context, 'Không tìm thấy verification ID. Vui lòng gửi lại mã OTP.');
      return;
    }

    try {
      // Tạo credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpSms,
      );

      // Thử đăng nhập với retry logic
      UserCredential? userCredential;
      int retryCount = 0;

      while (retryCount < MAX_RETRIES && userCredential == null) {
        try {
          userCredential = await firebaseAuth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'session-expired') {
            // Nếu session expired, yêu cầu gửi lại OTP
            showError(context, 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.');
            return;
          } else if (retryCount < MAX_RETRIES - 1) {
            // Chờ một chút trước khi thử lại
            await Future.delayed(const Duration(seconds: RETRY_DELAY_SECONDS));
            retryCount++;
            continue;
          }
          rethrow;
        }
      }

      if (userCredential == null) {
        throw Exception('Không thể xác thực sau nhiều lần thử');
      }

      // Lấy token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Không lấy được ID token');
      }

      // Tiếp tục với đăng ký
      await registerAndSignIn(context, idToken);
    } on FirebaseAuthException catch (e) {
      handleFirebaseError(context, e);
    } catch (e) {
      showError(context, 'Lỗi không xác định: ${e.toString()}');
    }
  }

  void handleFirebaseError(BuildContext context, FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'session-expired':
        message = 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.';
        break;
      case 'invalid-verification-code':
        message = 'Mã OTP không đúng. Vui lòng kiểm tra lại.';
        break;
      default:
        message = 'Lỗi xác thực: ${e.message}';
    }
    showError(context, message);
  }

  void showError(BuildContext context, String message) {
    showSnackBar(
      context: context,
      content: message,
      icon: AssetsConstants.iconError,
      backgroundColor: Colors.red,
      textColor: AssetsConstants.whiteColor,
    );
  }

  Future<void> registerAndSignIn(BuildContext context, String idToken) async {
    state = const AsyncLoading();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final userInfo =
          await SharedPreferencesUtils.getSignInRequestInfo('sign-up');

      if (userInfo == null) {
        throw Exception('Không tìm thấy thông tin đăng ký');
      }

      final requestRegister = SignUpRequest(
        email: userInfo.email,
        name: userInfo.name,
        phone: formatPhoneNumber(userInfo.phone),
        password: userInfo.password,
      );

      // Verify token
      await authRepository.verifyToken(
          request: OTPVerifyRequest(idToken: idToken));

      // Sign up
      final user = await authRepository.signUpAndRes(request: requestRegister);

      // Save user data
      final userModel = UserModel(
        id: user.payload.id,
        email: user.payload.email,
        tokens: user.payload.tokens,
      );

      ref.read(authProvider.notifier).update((state) => userModel);
      await SharedPreferencesUtils.setInstance(userModel, 'user_token');

      // Navigate
      context.router.replaceAll([const TabViewScreenRoute()]);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode ?? error.onStatusDio();
      handleAPIError(
        statusCode: statusCode,
        stateError: error,
        context: context,
      );
    } catch (e) {
      showError(context, 'Lỗi đăng ký: ${e.toString()}');
    }
  }
}
