import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:auto_route/auto_route.dart';
import 'package:icons_plus/icons_plus.dart';

// config
import 'package:movemate/configs/routes/app_router.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/commons/functions/functions_common_export.dart';
import 'package:movemate/utils/resources/validations.dart';

// controller
import 'package:movemate/features/auth/presentation/widgets/custom_scaford.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';

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
    if (formKey.currentState!.validate()) {
      unfocus(context);
      await ref.read(signInControllerProvider.notifier).signIn(
            email: email,
            phone: phoneNumber,
            password: password,
            context: context,
          );
      print("click : done");
    } else {
      print("Form is not valid.");
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

    final state = ref.watch(signInControllerProvider);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(flex: 1, child: SizedBox(height: 10)),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
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
                        const SizedBox(height: 20.0),

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

                        if (isEmailSelected.value) ...[
                          TextInput(
                            textController: email,
                            hintTextLable: "Email",
                            hintText: 'Nhập email của bạn',
                            onValidate: (val) => emailErrorText(val),
                            autoFocus: true,
                          ),
                          const SizedBox(height: 25.0),
                        ] else ...[
                          PhoneInput(
                            textController: phoneNumber,
                            hintTextLable: "Số điện thoại",
                            hintText: 'Nhập số điện thoại',
                            onValidate: (val) => phoneNumberErrorText(val),
                            autoFocus: true,
                          ),
                          const SizedBox(height: 25.0),
                        ],

                        PasswordInput(
                          textEditingController: password,
                          hintTextLable: "Mật khẩu",
                          hintText: 'Nhập mật khẩu',
                          onValidate: (val) => passwordErrorText(val),
                          autoFocus: false,
                        ),
                        const SizedBox(height: 25.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.router.replace(SignUpScreenRoute());
                              },
                              child: const LabelText(
                                content: 'Chưa có tài khoản?',
                                size: AssetsConstants.defaultFontSize - 10.0,
                                fontWeight: FontWeight.w700,
                                color: AssetsConstants.mainColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
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
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Logo(Logos.google),
                                  const SizedBox(width: 20),
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
      ),
    );
  }
}
