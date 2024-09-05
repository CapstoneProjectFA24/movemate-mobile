import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:auto_route/auto_route.dart';
import '../custom_scaford.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../utils/constants/asset_constant.dart';
import '../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../utils/resources/validations.dart';

@RoutePage()
class SignUpScreen extends HookConsumerWidget with Validations {
  SignUpScreen({super.key});


    // handle submit
  void submit({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required WidgetRef ref,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // if (formKey.currentState!.validate()) {
    //   unfocus(context);
    //   await ref.read(signInControllerProvider.notifier).signIn(
    //         email,
    //         password,
    //         context,
    //       );
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    final username = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final phoneNumber = useTextEditingController();

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
                  // key: _formSignInKey,
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
                      TextInput(
                        textController: username,
                        hintTextLable: "Tên đăng nhập",
                        hintText: 'Nhập tên',
                        onValidate: (val) => '',
                        autoFocus: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextInput(
                        textController: email,
                        hintTextLable: "Email",
                        hintText: 'Nhập email',
                        onValidate: (val) => '',
                        autoFocus: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextInput(
                        textController: phoneNumber,
                        hintTextLable: "Điện thoại",
                        hintText: 'Nhập số điện thoại',
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
                        // onValidate: (val) => passwordMinErrorText(val),
                        onValidate: (val) => (val),
                        autoFocus: false,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),


              Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (bool? value) {
                              // setState(() {
                              //   agreePersonalData = value!;
                              // });
                            },
                            activeColor: AssetsConstants.mainColor,
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ValueListenableBuilder4(
                        first: username,
                        second: email,
                        third: phoneNumber,
                        fourth: password ,
                        builder: (_, a, b,c,d, __) => SizedBox(
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
                                username: username.text.trim(),
                                email: email.text.trim(),
                                phoneNumber: phoneNumber.text.trim(),
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
                            content: 'Bạn đã có tài khoản?',
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
                                  // builder: (e) => const SignUpScreen(),
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const LabelText(
                              content: 'Đăng nhập',
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
