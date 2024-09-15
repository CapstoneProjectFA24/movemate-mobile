import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// screen
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:movemate/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:movemate/features/booking/presentation/screens/booking_select_package_screen.dart';
import 'package:movemate/features/booking/presentation/screens/vehicles_available_screen.dart';
import 'package:movemate/features/payment/presentation/screens/peyment_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_screen/promotion_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_detail_screen/promotion_details.dart';
import 'package:movemate/features/home/presentation/screens/home_screen.dart';
import 'package:movemate/features/package/presentation/package_detail_screen/package_detail_screen.dart';
import 'package:movemate/features/profile/presentation/profile_screen.dart';
import 'package:movemate/features/booking/presentation/screens/booking_screen.dart';
import 'package:movemate/features/order/presentation/screens/order.screen.dart';
import 'package:movemate/splash_screen.dart';
import 'package:movemate/tab_screen.dart';
import 'package:movemate/onboarding_screen.dart';
import 'guard/onboarding_guard.dart';

// model
import 'package:movemate/features/promotion/data/models/promotion_model.dart';
import 'package:movemate/features/booking/data/models/booking_models.dart';

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
          initial: true,
          page: PaymentScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: SplashScreenRoute.page,
        ),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter(ref: ref));
