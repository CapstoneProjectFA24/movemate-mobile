import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// utils
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// bloc-widget
import '../../widgets/otp_verification/otp_field.dart';

// import 'otp_verification_controller.dart';

@RoutePage()
class OTPVerificationScreen extends HookConsumerWidget {
  const OTPVerificationScreen({
    super.key,
    // required this.phoneNumber,
    // required this.verifyType,
  })  : phoneNumber = '123456789',
        verifyType = VerificationOTPType.firsttimelog;
  // fake trước mốt đổi required lại

  final String phoneNumber;
  final VerificationOTPType verifyType;

  // countdown resent
  void startTimer({
    required ValueNotifier<Timer?> timer,
    required ValueNotifier<int> start,
    required ValueNotifier<bool> wait,
  }) {
    const onsec = Duration(seconds: 1);
    timer.value = Timer.periodic(onsec, (timer) {
      if (start.value == 0) {
        timer.cancel();
        wait.value = false;
      } else {
        start.value--;
      }
    });
  }

  // get otp code
  Future<void> verifyPhoneNumber({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    // await ref
    //     .read(otpVerificationControllerProvider.notifier)
    //     .checkPhoneNumber(phoneNumber: phoneNumber, context: context);

    //fake
    await Future.delayed(const Duration(seconds: 2));
    showSnackBar(
      context: context,
      content: 'Mã OTP mới đã được gửi đến số điện thoại của bạn',
      icon: AssetsConstants.iconSuccess,
      backgroundColor: AssetsConstants.mainColor,
      textColor: AssetsConstants.whiteColor,
    );
  }

  // handle submit
  void submit({
    required WidgetRef ref,
    required BuildContext context,
    required String otpCode,
  }) async {
    // await ref.read(otpVerificationControllerProvider.notifier).verifyOTPCode(
    //       phoneNumber: phoneNumber,
    //       code: otpCode,
    //       context: context,
    //       verifyType: verifyType,
    //     );

    //fake
    await Future.delayed(const Duration(seconds: 2));
    if (otpCode == '123456') {
      showSnackBar(
        context: context,
        content: 'Xác thực OTP thành công!',
        icon: AssetsConstants.iconSuccess,
        backgroundColor: AssetsConstants.mainColor,
        textColor: AssetsConstants.whiteColor,
      );
      // next screen
    } else {
      showSnackBar(
        context: context,
        content: 'Mã OTP không chính xác. Vui lòng thử lại.',
        icon: AssetsConstants.iconSuccess,
        backgroundColor: Colors.red,
        textColor: AssetsConstants.whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // init
    final size = MediaQuery.sizeOf(context);
    final timer = useState<Timer?>(null);
    final start = useState(30);
    final wait = useState(true);
    // final state = ref.watch(otpVerificationControllerProvider);

    // text controller
    final otp_1 = useTextEditingController(),
        otp_2 = useTextEditingController(),
        otp_3 = useTextEditingController(),
        otp_4 = useTextEditingController(),
        otp_5 = useTextEditingController(),
        otp_6 = useTextEditingController();

    // call once when build done
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showSnackBar(
          context: context,
          content: 'Mã OTP đã được gửi đến số điện thoại của bạn',
          icon: AssetsConstants.iconSuccess,
          backgroundColor: AssetsConstants.mainColor,
          textColor: AssetsConstants.whiteColor,
        );
        startTimer(timer: timer, start: start, wait: wait);
        wait.value = true;
      });

      return () {
        timer.value?.cancel();
      };
    }, const []);

    return LoadingOverlay(
      // isLoading: state.isLoading,
      isLoading: false,
      child: Scaffold(
        backgroundColor: AssetsConstants.whiteColor,
        appBar: const CustomAppBar(
          backgroundColor: AssetsConstants.whiteColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              right: AssetsConstants.defaultPadding,
              left: AssetsConstants.defaultPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText(
                  content: 'Mã xác nhận OTP',
                  size: AssetsConstants.defaultFontSize - 8.0,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: size.height * 0.01),
                LabelText(
                  content:
                      'Hãy nhập mã gồm 6 số vừa được gửi đến số điện thoại: $phoneNumber',
                  size: AssetsConstants.defaultFontSize - 12.0,
                  fontWeight: FontWeight.w700,
                  color: AssetsConstants.subtitleColorM,
                ),
                SizedBox(height: size.height * 0.02),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OTPField(
                        size: size,
                        textController: otp_1,
                        isFirst: true,
                      ),
                      OTPField(
                        size: size,
                        textController: otp_2,
                      ),
                      OTPField(
                        size: size,
                        textController: otp_3,
                      ),
                      OTPField(
                        size: size,
                        textController: otp_4,
                      ),
                      OTPField(
                        size: size,
                        textController: otp_5,
                      ),
                      OTPField(
                        size: size,
                        textController: otp_6,
                        isFinal: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Bạn không nhận được mã?',
                        style: TextStyle(
                          fontSize: AssetsConstants.defaultFontSize - 12.0,
                          fontWeight: FontWeight.w500,
                          color: AssetsConstants.subtitleColorM,
                        ),
                      ),
                      TextSpan(
                        text: wait.value
                            ? ' Gửi lại (${start.value})'
                            : ' Gửi lại',
                        style: TextStyle(
                          fontSize: AssetsConstants.defaultFontSize - 12.0,
                          fontWeight: FontWeight.w700,
                          color: wait.value
                              ? AssetsConstants.subtitleColorM
                              : AssetsConstants.mainColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = wait.value
                              ? null
                              : () async {
                                  await verifyPhoneNumber(
                                      ref: ref, context: context);
                                  start.value = 30;
                                  startTimer(
                                    timer: timer,
                                    start: start,
                                    wait: wait,
                                  );
                                  wait.value = true;
                                },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: size.height * 0.04),
          padding: const EdgeInsets.only(
            right: AssetsConstants.defaultPadding,
            left: AssetsConstants.defaultPadding,
          ),
          child: ValueListenableBuilder6(
            first: otp_1,
            second: otp_2,
            third: otp_3,
            fourth: otp_4,
            fifth: otp_5,
            sixth: otp_6,
            builder: (_, a, b, c, d, e, f, __) => CustomButton(
              width: size.width * 1,
              height: size.height * 0.05,
              isActive: a.text.length +
                      b.text.length +
                      c.text.length +
                      d.text.length +
                      e.text.length +
                      f.text.length ==
                  6,
              content: 'Xác nhận',
              onCallback: () => submit(
                ref: ref,
                context: context,
                otpCode: otp_1.text +
                    otp_2.text +
                    otp_3.text +
                    otp_4.text +
                    otp_5.text +
                    otp_6.text,
              ),
              backgroundColor: (a.text.length +
                          b.text.length +
                          c.text.length +
                          d.text.length +
                          e.text.length +
                          f.text.length ==
                      6)
                  ? AssetsConstants.mainColor
                  : AssetsConstants.subtitleColor,
              size: AssetsConstants.defaultFontSize - 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
