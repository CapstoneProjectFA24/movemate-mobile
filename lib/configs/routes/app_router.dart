import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// screen
import 'package:movemate/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:movemate/features/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:movemate/features/booking/presentation/booking_select_package_screen.dart';
import 'package:movemate/features/booking/presentation/vehicles_available_screen.dart';
import 'package:movemate/features/promotion/presentation/promotion_screen/promotion_screen.dart';
import 'package:movemate/features/promotion/presentation/promotion_detail_screen/promotion_details.dart';
import 'package:movemate/features/home/presentation/home_screen.dart';
import 'package:movemate/features/package/presentation/package_detail_screen/package_detail_screen.dart';
import 'package:movemate/features/profile/presentation/profile_screen.dart';
import 'package:movemate/features/booking/presentation/booking_screen.dart';
import 'package:movemate/features/order/presentation/order.screen.dart';
import 'package:movemate/splash_screen.dart';
import 'package:movemate/tab_screen.dart';
import 'package:movemate/onboarding_screen.dart';
import 'guard/onboarding_guard.dart';

// model
import 'package:movemate/features/promotion/domain/models/promotion_model.dart';
import 'package:movemate/features/booking/domain/models/booking_models.dart';

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
          // initial: true,
          page: SignInScreenRoute.page,
        ),
        AutoRoute(
          page: SignUpScreenRoute.page,
        ),
        // Màn hình Onboarding
        AutoRoute(
          page: OnboardingScreenRoute.page,
        ),
        AutoRoute(
          page: TabViewScreenRoute.page,
          initial: true,
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
          page: PromotionScreenRoute.page,
        ),
        AutoRoute(page: PromotionDetailScreenRoute.page),

        // flow booking
        AutoRoute(
          // initial: true,
          page: BookingScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: AvailableVehiclesScreenRoute.page,
        ),

        AutoRoute(page: PackageDetailScreenRoute.page),
        AutoRoute(
          // initial: true,
          page: BookingSelectPackageScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: OrderScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: SplashScreenRoute.page,
        ),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter(ref: ref));
