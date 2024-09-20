import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:auto_route/auto_route.dart';
import 'package:icons_plus/icons_plus.dart';

// screen
import 'package:movemate/features/auth/presentation/screens/privacy_term/privacy_screen.dart';
import 'package:movemate/features/auth/presentation/screens/privacy_term/term_screen.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_screen.dart';
import '../../widgets/custom_scaford.dart';

// utils
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/commons/functions/functions_common_export.dart';
import 'package:movemate/utils/resources/validations.dart';

// controller
import 'sign_up_controller.dart';

@RoutePage()
class SignUpScreen extends HookConsumerWidget with Validations {
  SignUpScreen({super.key});

  // handle submit
  void submit({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (formKey.currentState!.validate()) {
      unfocus(context);
      await ref.read(signUpControllerProvider.notifier).signUp(
            email: email,
            name: name,
            phone: phone,
            password: password,
            context: context,
          );
      print("click : done");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    final state = ref.watch(signUpControllerProvider);

    final name = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final phone = useTextEditingController();

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final agreeToTerms = useState(false);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabelText(
                          content: 'Đăng Kí'.toUpperCase(),
                          size: AssetsConstants.defaultFontSize - 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                            labelText: 'Tên', // Label that remains visible
                            hintText: 'Nhập tên của bạn', // Hint text
                            hintStyle: TextStyle(
                              color: Colors.grey, // Color of the hint text
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Color of the label text
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AssetsConstants
                                    .mainColor, // Border color when focused
                                width: 2.0, // Border width when focused
                              ),
                            ),
                          ),
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black, // Color of the input text
                          ),
                          validator: (val) => val!.isEmpty ? 'Bắt buộc' : null,
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email', // Label that remains visible
                            hintText: 'Nhập email của bạn', // Hint text
                            hintStyle: TextStyle(
                              color: Colors.grey, // Color of the hint text
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Color of the label text
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AssetsConstants
                                    .mainColor, // Border color when focused
                                width: 2.0, // Border width when focused
                              ),
                            ),
                          ),
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black, // Color of the input text
                          ),
                          validator: (val) => val!.isEmpty ? 'Bắt buộc' : null,
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: phone,
                          decoration: const InputDecoration(
                            labelText:
                                'Số điện thoại', // Label that remains visible
                            hintText: 'Nhập số điện thoại', // Hint text
                            hintStyle: TextStyle(
                              color: Colors.grey, // Color of the hint text
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Color of the label text
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AssetsConstants
                                    .mainColor, // Border color when focused
                                width: 2.0, // Border width when focused
                              ),
                            ),
                          ),
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black, // Color of the input text
                          ),
                          validator: (val) => val!.isEmpty ? 'Bắt buộc' : null,
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: password,
                          decoration: const InputDecoration(
                            labelText: 'Mật khẩu', // Label that remains visible
                            hintText: 'Nhập mật khẩu', // Hint text
                            hintStyle: TextStyle(
                              color: Colors.grey, // Color of the hint text
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Color of the label text
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AssetsConstants
                                    .mainColor, // Border color when focused
                                width: 2.0, // Border width when focused
                              ),
                            ),
                          ),
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black, // Color of the input text
                          ),
                          validator: (val) => val!.isEmpty ? 'Bắt buộc' : null,
                        ),
                        const SizedBox(height: 25.0),
                        // Terms and Conditions Checkbox with TapGestureRecognizer
                        Row(
                          children: [
                            Checkbox(
                              value: agreeToTerms.value,
                              onChanged: (bool? value) {
                                // Toggle checkbox state
                                agreeToTerms.value = value ?? false;
                              },
                              activeColor: AssetsConstants.mainColor,
                              checkColor: Colors.white,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Tôi đồng ý với các ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: 'Điều khoản sử dụng',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle terms tap
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TermOfUseScreen(),
                                            ),
                                          );
                                        },
                                    ),
                                    const TextSpan(text: ' và '),
                                    TextSpan(
                                      text: 'Chính sách bảo mật',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle privacy policy tap
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PrivacyPolicyScreen(),
                                            ),
                                          );
                                        },
                                    ),
                                    const TextSpan(text: ' của MoveMate.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Button with ValueListenableBuilder for form fields
                        ValueListenableBuilder4(
                          first: name,
                          second: email,
                          third: phone,
                          fourth: password,
                          builder: (_, a, b, c, d, __) => SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              width: size.width * 1,
                              height: size.height * 0.06,
                              content: 'Đăng Kí',
                              onCallback: () {
                                submit(
                                  context: context,
                                  formKey: formKey,
                                  ref: ref,
                                  name: name.text.trim(),
                                  email: email.text.trim(),
                                  phone: phone.text.trim(),
                                  password: password.text.trim(),
                                );
                              },
                              // Enable the button only when fields are not empty AND checkbox is checked
                              isActive: a.text.isNotEmpty &&
                                  b.text.isNotEmpty &&
                                  c.text.isNotEmpty &&
                                  d.text.isNotEmpty &&
                                  agreeToTerms.value, // <-- Checkbox condition
                              size: AssetsConstants.defaultFontSize - 8.0,
                              backgroundColor: (a.text.isNotEmpty &&
                                      b.text.isNotEmpty &&
                                      c.text.isNotEmpty &&
                                      d.text.isNotEmpty &&
                                      agreeToTerms
                                          .value) // <-- Checkbox condition
                                  ? AssetsConstants.mainColor
                                  : AssetsConstants.primaryLighter,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: LabelText(
                                content: 'hoặc tiếp tục với',
                                size: AssetsConstants.defaultFontSize - 10.0,
                                fontWeight: FontWeight.w700,
                                color: AssetsConstants.subtitleColor,
                                textDecoration: TextDecoration.none,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.8, // Adjust width as needed
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the button
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    spreadRadius: 2, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(0, 3), // Shadow offset
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Logo(Logos.google), // Google icon
                                  const SizedBox(
                                      width: 20), // Space between icon and text
                                  const Text(
                                    'Google',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (e) => const SignUpScreen(),
                                      builder: (context) => SignInScreen()),
                                );
                              },
                              child: const LabelText(
                                content: 'Đã có tài khoản?',
                                size: AssetsConstants.defaultFontSize - 10.0,
                                fontWeight: FontWeight.w700,
                                color: AssetsConstants.mainColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
