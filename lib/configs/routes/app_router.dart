import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// guard
import 'guard/onboarding_guard.dart';

// screen
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:movemate/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:movemate/features/auth/presentation/screens/privacy_term/privacy_screen.dart';
import 'package:movemate/features/auth/presentation/screens/privacy_term/term_screen.dart';
import 'package:movemate/features/auth/presentation/screens/otp_verification/otp_verification_screen.dart';

import 'package:movemate/features/booking/presentation/screens/booking_select_package_screen.dart';
import 'package:movemate/features/booking/presentation/screens/vehicles_available_screen.dart';
import 'package:movemate/features/booking/presentation/screens/booking_screen.dart';

import 'package:movemate/features/home/presentation/screens/location_selection_screen.dart';
import 'package:movemate/features/payment/presentation/screens/payment_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_screen/promotion_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_detail_screen/promotion_details.dart';
import 'package:movemate/features/home/presentation/screens/home_screen.dart';
import 'package:movemate/features/package/presentation/package_detail_screen/package_detail_screen.dart';
import 'package:movemate/features/profile/presentation/profile_screen.dart';
import 'package:movemate/features/order/presentation/screens/order.screen.dart';
import 'package:movemate/splash_screen.dart';
import 'package:movemate/tab_screen.dart';
import 'package:movemate/onboarding_screen.dart';

// model
import 'package:movemate/features/promotion/data/models/promotion_model.dart';

// utils
import 'package:movemate/utils/enums/enums_export.dart';

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
        AutoRoute(page: SignInScreenRoute.page),
        AutoRoute(page: SignUpScreenRoute.page),
        AutoRoute(
          initial: true,
          page: OTPVerificationScreenRoute.page,
        ),

        // Màn hình Onboarding
        AutoRoute(page: OnboardingScreenRoute.page),

        // Màn hình chính
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

        // màn hình khuyến mãi
        AutoRoute(
          page: PromotionScreenRoute.page,
        ),
        AutoRoute(
          page: PromotionDetailScreenRoute.page,
        ),

        // flow booking
        AutoRoute(
          // initial: true,
          page: BookingScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: AvailableVehiclesScreenRoute.page,
        ),

        //TODO
        AutoRoute(
          page: PackageDetailScreenRoute.page,
        ),

        AutoRoute(
          page: BookingSelectPackageScreenRoute.page,
        ),

        //  order flow
        AutoRoute(
          page: OrderScreenRoute.page,
        ),
        AutoRoute(
          page: PaymentScreenRoute.page,
        ),
        AutoRoute(
          page: LocationSelectionScreenRoute.page,
        ),
        AutoRoute(
          page: SplashScreenRoute.page,
        ),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter(ref: ref));
