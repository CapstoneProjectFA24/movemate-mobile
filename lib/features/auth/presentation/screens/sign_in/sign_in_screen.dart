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
  }) async {
      print('Submit function called');
    if (formKey.currentState!.validate()) {
      unfocus(context);
      print('Email: $email, Password: $password');
      // await ref.read(signInControllerProvider.notifier).signIn(
      //       email,
      //       password,
      //       context,
      //     );
      
    }else {
       print("fail to valid");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final email = useTextEditingController();
    final password = useTextEditingController();
    // final state = ref.watch(signInControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    return CustomScaffold(
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
                        content: 'Đăng nhập'.toUpperCase(),
                        size: AssetsConstants.defaultFontSize - 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextInput(
                        textController: email,
                        hintTextLable: "Tài khoản",
                        hintText: 'Nhập tài khoản',
                        onValidate: (val) => '',
                        autoFocus: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      PasswordInput(
                        textEditingController: password,
                        hintTextLable: "Mật khẩu",
                        hintText: 'Nhập mật khẩu',
                        onValidate: (val) => passwordMinErrorText(val),
                        autoFocus: false,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Checkbox(
                              //   value: rememberPassword,
                              //   onChanged: (bool? value) {
                              //     setState(() {
                              //       rememberPassword = value!;
                              //     });
                              //   },
                              //   activeColor: lightColorScheme.primary,
                              // ),
                              // const Text(
                              //   'Remember me',
                              //   style: TextStyle(
                              //     color: Colors.black45,
                              //   ),
                              // ),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              // Mở route điền mail
                              // context.router.push(EnterEmailScreenRoute());
                            },
                            child: const LabelText(
                              content: 'Quên mật khẩu?',
                              size: AssetsConstants.defaultFontSize - 8.0,
                              fontWeight: FontWeight.w700,
                              color: AssetsConstants.subtitleColorM,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ValueListenableBuilder2(
                        first: email,
                        second: password,
                        builder: (_, a, b, __) => SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            width: size.width * 1,
                            height: size.height * 0.06,
                            content: 'Đăng nhập',
                            onCallback: () {
                              submit(
                                context: context,
                                formKey: formKey,
                                ref: ref,
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );
                            },
                            isActive: a.text.isNotEmpty && b.text.isNotEmpty,
                            size: AssetsConstants.defaultFontSize - 8.0,
                            backgroundColor:
                                (a.text.isNotEmpty && b.text.isNotEmpty)
                                    ? AssetsConstants.mainColor
                                    : AssetsConstants.primaryLighter,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
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
                              content: 'Hoặc đăng nhập với',
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Logo(Logos.facebook_f),
                          Logo(Logos.google),
                          Logo(Logos.apple),
                          Logo(Logos.whatsapp),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LabelText(
                            content: 'Bạn không có tài khoản?',
                            size: AssetsConstants.defaultFontSize - 10.0,
                            fontWeight: FontWeight.w700,
                            color: AssetsConstants.subtitleColorM,
                            textDecoration: TextDecoration.none,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const LabelText(
                              content: 'Đăng kí',
                              size: AssetsConstants.defaultFontSize - 10.0,
                              fontWeight: FontWeight.w700,
                              color: AssetsConstants.blackColor,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
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
