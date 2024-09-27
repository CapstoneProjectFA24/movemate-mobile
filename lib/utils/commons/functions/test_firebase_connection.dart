import 'package:movemate/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> testFirebaseConnectionWithPhone(String phoneNumber) async {
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Tự động xác thực
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        print('Kết nối với Firebase thành công: ${userCredential.user?.uid}');

        // Lấy firebaseIdToken
        String? idToken = await userCredential.user?.getIdToken();

        if (idToken != null) {
          print('Firebase ID Token: $idToken');
        } else {
          print('Không thể lấy ID Token');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Xác thực số điện thoại thất bại: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Mã xác thực đã được gửi đến $phoneNumber');
        // Bạn có thể thêm logic để nhập mã OTP và xác thực ở đây
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Thời gian lấy mã xác thực đã hết.');
      },
    );
  } catch (e) {
    print('Kết nối với Firebase thất bại: $e');
  }
}


Future<void> testFirebaseConnection() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    print('Kết nối với Firebase thành công: ${userCredential.user?.uid}');

    User? user = userCredential.user;
     // Lấy firebaseIdToken
    String? idToken = await user?.getIdToken();

    if (idToken != null) {
      print('Firebase ID Token: $idToken');
    } else {
      print('Không thể lấy ID Token');
    }
  } catch (e) {
    print('Kết nối với Firebase thất bại: $e');
  }
}
