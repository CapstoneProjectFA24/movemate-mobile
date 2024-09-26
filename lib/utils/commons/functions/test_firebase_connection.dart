import 'package:firebase_auth/firebase_auth.dart';

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
