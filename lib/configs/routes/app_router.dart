import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/guard/auth_guard.dart';
import 'package:movemate/features/booking/presentation/screens/booking_screen_service.dart';
import 'package:movemate/features/booking/presentation/screens/review_screen/review_at_home/review_at_home.dart';
import 'package:movemate/features/booking/presentation/screens/review_screen/review_online/review_online.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_screen.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/fee_system/system_fee_screen.dart';
import 'package:movemate/features/home/presentation/screens/map_test_screen.dart';
import 'package:movemate/features/home/presentation/screens/voucher/voucher_details_screen.dart';
import 'package:movemate/features/home/presentation/screens/voucher/voucher_screen.dart';
import 'package:movemate/features/order/presentation/screens/chat_screen/chat_with_staff_screen.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/confirm_last_payment/confirm_last_payment.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/incidents_screen/incidents_screen.dart';
import 'package:movemate/features/order/presentation/widgets/details/time_line_booking.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_payment_screen.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_transaction_result_cash_payment/cash_payment_waiting.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_transaction_result_cash_payment/last_transaction_result_cash_payment.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_transaction_result_screen.dart';
import 'package:movemate/features/payment/presentation/screens/last_payment/last_transaction_result_screen_by_wallet.dart';
import 'package:movemate/features/payment/presentation/screens/recharge_wallet/transaction_result_screen_recharge_wallet.dart';
import 'package:movemate/features/payment/presentation/screens/transaction_details_order.dart';
import 'package:movemate/features/payment/presentation/screens/deposite_payment/transaction_result_screen.dart';
import 'package:movemate/features/payment/presentation/screens/deposite_payment/transaction_result_screen_by_wallet.dart';
import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';

import 'package:movemate/features/profile/presentation/screens/contact/contact_screen.dart';
import 'package:movemate/features/payment/presentation/screens/deposite_payment/payment_screen.dart';
import 'package:movemate/features/profile/presentation/screens/incidents_list_screen/incident_details_screen.dart';
import 'package:movemate/features/profile/presentation/screens/incidents_list_screen/incidents_list_screen.dart';
import 'package:movemate/features/profile/presentation/screens/transaction_screen/list_transaction_screen.dart';
import 'package:movemate/features/profile/presentation/screens/wallet/combined_wallet_statistics_screen.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_detail_screen/coupon_detail_screen.dart';
// import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/widgets/cart_voucher.dart';
import 'package:movemate/features/test-payment/test_payment_screen.dart';
import 'package:movemate/features/test_cloudinary/test_cloudinary_screen.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/models/loading_screen/loading_screen.dart';
import 'package:movemate/models/result_register_booking_screen/confirm_service_booking.dart';
import 'package:movemate/models/result_register_booking_screen/register_success.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';

// guard
import 'guard/onboarding_guard.dart';

// screen-auth
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:movemate/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:movemate/features/auth/presentation/screens/privacy_term/privacy_screen.dart';
import 'package:movemate/features/auth/presentation/screens/privacy_term/term_screen.dart';
import 'package:movemate/features/auth/presentation/screens/otp_verification/otp_verification_screen.dart';

// screen-home
import 'package:movemate/features/home/presentation/screens/location_selection_screen.dart';
import 'package:movemate/features/home/presentation/screens/home_screen.dart';

// screen-booking

import 'package:movemate/features/booking/presentation/screens/vehicles_screen/vehicles_available_screen.dart';
import 'package:movemate/features/booking/presentation/screens/booking_screen.dart';
import 'package:movemate/features/booking/presentation/screens/vehicles_list_price/vehicle_price_list_screen.dart';

// order
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/order_details_screen.dart';
import 'package:movemate/features/order/presentation/screens/order_screen/order_screen.dart';

import 'package:movemate/features/profile/presentation/screens/wallet/wallet_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_screen/promotion_screen.dart';
import 'package:movemate/features/promotion/presentation/screens/promotion_detail_screen/promotion_details.dart';
import 'package:movemate/features/profile/presentation/screens/profile_detail_screen/profile_detail_screen.dart';
import 'package:movemate/features/profile/presentation/screens/info_screen/info_screen.dart';
import 'package:movemate/features/package/presentation/package_detail_screen/package_detail_screen.dart';
import 'package:movemate/features/profile/presentation/screens/profile_screen/profile_screen.dart';
import 'package:movemate/splash_screen.dart';
import 'package:movemate/tab_screen.dart';
import 'package:movemate/onboarding_screen.dart';
import 'package:movemate/noti_exception.dart';
import 'package:movemate/features/order/presentation/screens/driver_tracking_map/driver_tracking_map.dart';
import 'package:movemate/features/order/presentation/screens/reviewer_tracking_map/reviewer_tracking_map.dart';

import 'package:movemate/features/test-payment/payment_result_screen.dart';

// model
import 'package:movemate/features/promotion/data/models/promotion_model.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
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
        AutoRoute(page: OTPVerificationScreenRoute.page),

        // Màn hình Onboarding
        AutoRoute(page: OnboardingScreenRoute.page),

        // Màn hình chính
        AutoRoute(
          page: TabViewScreenRoute.page,
          initial: true,
          guards: [
            OnboardingGuard(ref: _ref),
            AuthGuard(ref: _ref),
          ],
          children: [
            AutoRoute(page: HomeScreenRoute.page),
            AutoRoute(page: OrderScreenRoute.page),
            AutoRoute(page: PromotionScreenRoute.page),
            AutoRoute(
              page: ProfileScreenRoute.page,
            ),
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
        AutoRoute(
          page: CouponDetailScreenRoute.page,
        ),

        AutoRoute(page: ProfileScreenRoute.page),

        AutoRoute(
          page: ProfileDetailScreenRoute.page,
        ),
        AutoRoute(
          page: InfoScreenRoute.page,
        ),
        AutoRoute(
          page: WalletScreenRoute.page,
        ),
        AutoRoute(
          page: CombinedWalletStatisticsScreenRoute.page,
        ),
        AutoRoute(
          page: ContactScreenRoute.page,
        ),
        AutoRoute(
          page: VoucherScreenRoute.page,
        ),

        AutoRoute(
          page: ListTransactionScreenRoute.page,
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
        //  booking service flow
        AutoRoute(
          // initial: true,
          page: BookingScreenServiceRoute.page,
        ),
        //  booking service fee widget
        AutoRoute(
          // initial: true,
          page: SystemFeeScreenRoute.page,
        ),
        // review at home
        AutoRoute(
          // initial: true,
          page: ReviewAtHomeRoute.page,
        ),
        // review online
        AutoRoute(
          // initial: true,
          page: ReviewOnlineRoute.page,
        ),

        //TODO
        AutoRoute(
          page: PackageDetailScreenRoute.page,
        ),
        AutoRoute(
          page: ChatWithStaffScreenRoute.page,
        ),

        //  order flow
        AutoRoute(
          page: OrderScreenRoute.page,
        ),
        AutoRoute(
          page: TrackingDriverMapRoute.page,
        ),
        AutoRoute(
          page: ReviewerTrackingMapRoute.page,
        ),
        AutoRoute(
          page: OrderDetailsScreenRoute.page,
        ),
        //  test service screen
        AutoRoute(
          // initial: true,
          page: ServiceScreenRoute.page,
        ),

        //xem bảng giá niêm yết xe
        AutoRoute(
          // initial: true,
          page: VehiclePriceListScreenRoute.page,
        ),

        AutoRoute(
          // initial: true,
          page: PaymentScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: LastPaymentScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: ConfirmLastPaymentRoute.page,
        ),
        AutoRoute(
          page: SplashScreenRoute.page,
        ),
        //incident screen
        AutoRoute(
          page: IncidentsScreenRoute.page,
        ),
        //list incidents screen
        AutoRoute(
          page: IncidentsListScreenRoute.page,
        ),
        // incidents details screen
        AutoRoute(
          page: IncidentDetailsScreenRoute.page,
        ),
        AutoRoute(
          page: CartVoucherScreenRoute.page,
        ),
        //loading screen
        AutoRoute(
          // initial: true,
          page: LoadingScreenRoute.page,
        ),
        //register success screen
        AutoRoute(
          // initial: true,
          page: RegistrationSuccessScreenRoute.page,
        ),
        //register success screen
        AutoRoute(
          // initial: true,
          page: ConfirmServiceBookingScreenRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: CashPaymentWaitingRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: LastTransactionResultCashPaymentRoute.page,
        ),

        // test route
        AutoRoute(
          page: TestCloudinaryScreenRoute.page,
          // initial: true,
        ),

        AutoRoute(
          page: TestPaymentScreenRoute.page,
          // initial: true,
        ),
        //thanh toán thành công
        AutoRoute(
          page: TransactionResultScreenRoute.page,
          // initial: true,
        ),
        //thanh toán thành công
        AutoRoute(
          page: TransactionResultScreenByWalletRoute.page,
          // initial: true,
        ),
        //nap tiền thành công
        AutoRoute(
          page: TransactionResultScreenRechargeWalletRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: LastTransactionResultScreenRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: LastTransactionResultScreenByWalletRoute.page,
          // initial: true,
        ),

        //timeline test
        AutoRoute(
          page: TimeLineBookingRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: TransactionDetailsOrderRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: MapScreenTestRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: NotificationExceptScreenRoute.page,
          // initial: true,
        ),

        AutoRoute(page: PaymentResultScreenRoute.page),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter(ref: ref));
