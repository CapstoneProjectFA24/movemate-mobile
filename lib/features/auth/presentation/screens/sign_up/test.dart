// import 'package:flutter/material.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:dio/dio.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:movemate/features/auth/data/models/request/sign_up_request/sign_up_request.dart';
// import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
// import 'package:movemate/utils/constants/asset_constant.dart';
// import 'package:movemate/utils/commons/functions/api_utils.dart';
// import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
// import 'package:movemate/configs/routes/app_router.dart';

// part 'sign_up_controller.g.dart';

// @riverpod
// class SignUpController extends _$SignUpController {
//   late final AuthRepository _authRepository;
//   late final FirebaseAuth _firebaseAuth;

//   @override
//   FutureOr<void> build() {
//     _authRepository = ref.read(authRepositoryProvider);
//     _firebaseAuth = FirebaseAuth.instance;
//   }

//   Future<void> signUp({
//     required String email,
//     required String name,
//     required String phone,
//     required String password,
//     required BuildContext context,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       // Bước 1: Gửi OTP
//       await sendOTP(phone);
      
//       // Bước 2: Lưu thông tin đăng ký tạm thời
//       await _saveTemporarySignUpInfo(email, name, phone, password);
      
//       // Bước 3: Chuyển đến màn hình xác thực OTP
//       context.router.push(OTPVerificationRoute(phone: phone));
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//       showSnackBar(
//         context: context,
//         content: 'Đã xảy ra lỗi: ${e.toString()}',
//         icon: AssetsConstants.iconError,
//         backgroundColor: Colors.red,
//         textColor: AssetsConstants.whiteColor,
//       );
//     }
//   }

//   Future<void> sendOTP(String phoneNumber) async {
//     await _firebaseAuth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Xử lý xác thực tự động (thường xảy ra trên Android)
//         await _firebaseAuth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         throw Exception('Gửi OTP thất bại: ${e.message}');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         // Lưu verificationId để sử dụng khi xác thực OTP
//         _saveVerificationId(verificationId);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Xử lý timeout nếu cần
//       },
//     );
//   }

//   Future<void> _saveTemporarySignUpInfo(String email, String name, String phone, String password) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('temp_email', email);
//     await prefs.setString('temp_name', name);
//     await prefs.setString('temp_phone', phone);
//     await prefs.setString('temp_password', password);
//   }

//   Future<void> _saveVerificationId(String verificationId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('verification_id', verificationId);
//   }
// }