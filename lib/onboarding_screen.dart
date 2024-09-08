import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';

import 'package:movemate/utils/commons/widgets/onboarding/introduction.dart';
import 'package:movemate/utils/commons/widgets/onboarding/introduction_screen.dart';

import 'package:movemate/utils/constants/asset_constant.dart';

import 'configs/routes/app_router.dart';

final onboardingServiceProvider = Provider((ref) => OnboardingService());

@RoutePage()
class OnboardingScreen extends ConsumerWidget {
  final List<Introduction> list = [
    const Introduction(
        imageUrl: "assets/images/onboarding/onboarding1.png",
        title: "Chào Mừng Bạn Đến Với MoveMate!",
        subTitle:
            "Bất cứ nơi nào bạn đang ở, chuyển nhà dễ dàng với sự trợ giúp của MoveMate! Chúng tôi ở đây để làm cho việc chuyển nhà trở nên đơn giản và thuận tiện hơn bao giờ hết."),
    const Introduction(
      imageUrl: "assets/images/onboarding/onboarding2.png",
      title: "Tại Sao Chọn MoveMate?",
      subTitle:
          "Dễ Dàng và Tiện Lợi\nAn Toàn và Đáng Tin Cậy\nTiết Kiệm Thời Gian và Chi Phí",
    ),
    const Introduction(
      imageUrl: "assets/images/onboarding/onboarding3.png",
      title: "Đặt Xe Dễ Dàng",
      subTitle:
          "Chuyển nhà dễ dàng với sự trợ giúp của MoveMate. Chọn dịch vụ, nhập thông tin, và hoàn tất đặt xe chỉ trong vài phút. MoveMate giúp bạn tiết kiệm thời gian và công sức!",
    ),
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingService = ref.read(onboardingServiceProvider);

    return IntroScreenOnboarding(
      backgroudColor: AssetsConstants.whiteColor,
      foregroundColor: AssetsConstants.primaryLight,
      introductionList: list,
      onTapSkipButton: () async {
        try {
          await onboardingService.completeOnboarding();
          context.router.replace(const TabViewScreenRoute());
        } catch (e) {
          print('Error completing onboarding: $e');
        }
      },
      skipTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 18,
      ),
    );
  }
}

class OnboardingService {
  Future<bool> isOnboardingCompleted() async {
    return await SharedPreferencesUtils.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    await SharedPreferencesUtils.setOnboardingCompleted(true);
  }
}
