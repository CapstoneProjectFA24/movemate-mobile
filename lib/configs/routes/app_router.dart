import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:movemate/features/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:movemate/features/promotion/presentation/promotion_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/order/presentation/order_screen.dart';
import '../../tab_screen.dart';
import '../../onboarding_screen.dart';
import 'guard/onboarding_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends _$AppRouter {
  final Ref _ref;
  AppRouter({
    required Ref ref,
  }) : _ref = ref;

  @override
  List<AutoRoute> get routes => [
        // auth
        AutoRoute(
          page: SignInScreenRoute.page,
        ),
        AutoRoute(
          page: SignUpScreenRoute.page,
        ),
        // Màn hình Onboarding
        AutoRoute(
          page: OnboardingScreenRoute.page,
          initial: true,

        ),
        AutoRoute(
          page: TabViewScreenRoute.page,
          // initial: true,
          guards: [OnboardingGuard(ref: _ref)],
          // guards: [AuthGuard(ref: _ref)],
          children: [
            AutoRoute(page: HomeScreenRoute.page),
            AutoRoute(page: OrderScreenRoute.page),
            AutoRoute(page: PromotionScreenRoute.page),
            AutoRoute(page: ProfileScreenRoute.page),
          ],
        ),
        AutoRoute(
          page: HomeScreenRoute.page,
        ),
        AutoRoute(
          page: OrderScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: PromotionScreenRoute.page,
        ),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter(ref: ref));
