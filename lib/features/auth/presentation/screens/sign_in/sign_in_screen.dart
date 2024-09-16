import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../widgets/custom_scaford.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../../utils/constants/asset_constant.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/commons/functions/functions_common_export.dart';
import '../../../../../utils/resources/validations.dart';

@RoutePage()
class SignInScreen extends HookConsumerWidget with Validations {
  SignInScreen({super.key});

  // handle submit
  void submit({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    print('Submit function called');
    if (formKey.currentState!.validate()) {
      unfocus(context);
      print('Email: $email, Password: $password, Phone Number: $phoneNumber');
    } else {
      print("Xác thực không thành công");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final email = useTextEditingController();
    final password = useTextEditingController();
    final phoneNumber = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final isEmailSelected = useState(true);

    return CustomScaffold(
      child: Column(
        children: [
          // Space at the top
          const Expanded(flex: 1, child: SizedBox(height: 10)),

          // Main form container
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
                      // Title
                      LabelText(
                        content: 'Đăng nhập'.toUpperCase(),
                        size: AssetsConstants.defaultFontSize - 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 40.0),

                      // Email / Phone toggle section
                      Container(
                        width: size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => isEmailSelected.value = true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isEmailSelected.value
                                        ? Colors.white
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isEmailSelected.value
                                        ? [
                                            const BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4)
                                          ]
                                        : [],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => isEmailSelected.value = false,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !isEmailSelected.value
                                        ? Colors.white
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: !isEmailSelected.value
                                        ? [
                                            const BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4)
                                          ]
                                        : [],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Số điện thoại',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      // Conditional input fields based on toggle
                      if (isEmailSelected.value) ...[
                        // Email input field
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText:
                                'Tài khoản', // Label that remains visible
                            hintText: 'Nhập tài khoản', // Hint text
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
                      ] else ...[
                        // Phone Number input field
                        TextFormField(
                          controller: phoneNumber,
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
                      ],

                      // Password input field
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

                      // Forgot password & Create new account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              // Create account navigation
                              // context.router.push(CreateAccountScreenRoute());
                            },
                            child: const LabelText(
                              content: 'Tạo tài khoản',
                              size: AssetsConstants.defaultFontSize - 8.0,
                              fontWeight: FontWeight.w700,
                              color: AssetsConstants.mainColor,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              // Forgot password navigation
                              // context.router.push(EnterEmailScreenRoute());
                            },
                            child: const LabelText(
                              content: 'Quên mật khẩu?',
                              size: AssetsConstants.defaultFontSize - 8.0,
                              fontWeight: FontWeight.w700,
                              color: AssetsConstants.subtitleColorM,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),

                      // Login button with email & password validation
                      ValueListenableBuilder2(
                        first: isEmailSelected.value ? email : phoneNumber,
                        second: password,
                        builder: (_, a, b, __) => SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            width: size.width,
                            height: size.height * 0.06,
                            content: 'Đăng nhập',
                            onCallback: () {
                              submit(
                                context: context,
                                formKey: formKey,
                                ref: ref,
                                email: email.text.trim(),
                                password: password.text.trim(),
                                phoneNumber: phoneNumber.text.trim(),
                              );
                            },
                            isActive: (isEmailSelected.value
                                    ? a.text.isNotEmpty
                                    : phoneNumber.text.isNotEmpty) &&
                                b.text.isNotEmpty,
                            size: AssetsConstants.defaultFontSize - 8.0,
                            backgroundColor: (isEmailSelected.value
                                        ? a.text.isNotEmpty
                                        : phoneNumber.text.isNotEmpty) &&
                                    b.text.isNotEmpty
                                ? AssetsConstants.mainColor
                                : AssetsConstants.primaryLighter,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      // Or login with divider
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
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: LabelText(
                              content: 'hoặc đăng nhập với',
                              size: AssetsConstants.defaultFontSize - 10.0,
                              fontWeight: FontWeight.w700,
                              color: AssetsConstants.subtitleColor,
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
                      const SizedBox(height: 25.0),

                      // Social login options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.8, // Adjust width as needed
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color of the button
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
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
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}