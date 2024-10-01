import 'package:firebase_auth/firebase_auth.dart';

Future<void> testFirebaseConnectionWithPhone(String phoneNumber) async {
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('Kết nối với Firebase thành công: ${userCredential.user?.uid}');

        String? idToken = await userCredential.user?.getIdToken();

        print('Firebase ID Token: $idToken');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Xác thực số điện thoại thất bại: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Mã xác thực đã được gửi đến $phoneNumber');
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
    String? idToken = await user?.getIdToken();

    print('Firebase ID Token: $idToken');
  } catch (e) {
    print('Kết nối với Firebase thất bại: $e');
  }
}
