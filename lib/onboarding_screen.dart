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
          "Bất cứ nơi nào bạn đang ở, chuyển nhà dễ dàng hơn với sự trợ giúp của MoveMate! Chúng tôi không chỉ làm cho việc chuyển nhà trở nên thuận tiện, mà còn hơn thế nữa chúng tôi cung cấp sự AN TÂM khi chuyển nhà.",
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 12,
      ),
    ),
    const Introduction(
      imageUrl: "assets/images/onboarding/onboarding2.png",
      title: "Tại Sao Chọn MoveMate?",
      subTitle:
          "Dễ Dàng và Tiện Lợi\nAn Toàn và Đáng Tin Cậy\nTiết Kiệm Thời Gian và Chi Phí",
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 12,
      ),
    ),
    const Introduction(
      imageUrl: "assets/images/onboarding/onboarding3.png",
      title: "Đặt Xe Dễ Dàng",
      subTitle:
          "Chuyển nhà dễ dàng với sự trợ giúp của MoveMate. Chọn dịch vụ, nhập thông tin, và hoàn tất đặt xe chỉ trong vài phút. MoveMate giúp bạn tiết kiệm thời gian và công sức!",
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        fontSize: 12,
      ),
    ),
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingService = ref.read(onboardingServiceProvider);

    return IntroScreenOnboarding(
      backgroudColor: AssetsConstants.whiteColor,
      foregroundColor: AssetsConstants.mainColor,
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
        fontSize: 10,
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
