// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AvailableVehiclesScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AvailableVehiclesScreen(),
      );
    },
    BookingScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BookingScreen(),
      );
    },
    BookingScreenServiceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BookingScreenService(),
      );
    },
    CartVoucherScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartVoucherScreen(),
      );
    },
    CashPaymentWaitingRoute.name: (routeData) {
      final args = routeData.argsAs<CashPaymentWaitingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CashPaymentWaiting(
          key: args.key,
          bookingId: args.bookingId,
        ),
      );
    },
    ChatWithStaffScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ChatWithStaffScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatWithStaffScreen(
          key: args.key,
          staffId: args.staffId,
          staffName: args.staffName,
          staffRole: args.staffRole,
          bookingId: args.bookingId,
          staffImageAvatar: args.staffImageAvatar,
        ),
      );
    },
    CleaningServiceScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CleaningServiceScreen(),
      );
    },
    CombinedWalletStatisticsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CombinedWalletStatisticsScreen(),
      );
    },
    ConfirmLastPaymentRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmLastPaymentRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConfirmLastPayment(
          key: args.key,
          orderObj: args.orderObj,
          id: args.id,
        ),
      );
    },
    ConfirmServiceBookingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmServiceBookingScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConfirmServiceBookingScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    ContactScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ContactScreen(),
      );
    },
    CouponDetailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<CouponDetailScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CouponDetailScreen(
          key: args.key,
          promotion: args.promotion,
        ),
      );
    },
    DriverUploadedImageScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DriverUploadedImageScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DriverUploadedImageScreen(
          key: args.key,
          job: args.job,
        ),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    IncidentDetailsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<IncidentDetailsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IncidentDetailsScreen(
          key: args.key,
          incident: args.incident,
        ),
      );
    },
    IncidentsListScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IncidentsListScreen(),
      );
    },
    IncidentsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<IncidentsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IncidentsScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    InfoScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InfoScreen(),
      );
    },
    LastPaymentScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LastPaymentScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LastPaymentScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    LastTransactionResultCashPaymentRoute.name: (routeData) {
      final args =
          routeData.argsAs<LastTransactionResultCashPaymentRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LastTransactionResultCashPayment(
          key: args.key,
          order: args.order,
          status: args.status,
        ),
      );
    },
    LastTransactionResultScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LastTransactionResultScreenRouteArgs>(
          orElse: () => LastTransactionResultScreenRouteArgs(
                isSuccess: pathParams.getBool('isSuccess'),
                bookingId: pathParams.getString('bookingId'),
                allUri: pathParams.getString(''),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LastTransactionResultScreen(
          key: args.key,
          isSuccess: args.isSuccess,
          bookingId: args.bookingId,
          allUri: args.allUri,
        ),
      );
    },
    LastTransactionResultScreenByWalletRoute.name: (routeData) {
      final args =
          routeData.argsAs<LastTransactionResultScreenByWalletRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LastTransactionResultScreenByWallet(
          key: args.key,
          bookingId: args.bookingId,
          status: args.status,
        ),
      );
    },
    ListTransactionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ListTransactionScreen(),
      );
    },
    LoadingScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoadingScreen(),
      );
    },
    LocationSelectionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LocationSelectionScreen(),
      );
    },
    MapScreenTestRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapScreenTest(),
      );
    },
    NotificationExceptScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationExceptScreen(),
      );
    },
    OTPVerificationScreenRoute.name: (routeData) {
      final args = routeData.argsAs<OTPVerificationScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OTPVerificationScreen(
          key: args.key,
          phoneNumber: args.phoneNumber,
          verifyType: args.verifyType,
        ),
      );
    },
    OnboardingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingScreenRouteArgs>(
          orElse: () => const OnboardingScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingScreen(key: args.key),
      );
    },
    OrderDetailsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrderDetailsScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    OrderScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderScreen(),
      );
    },
    PackageDetailScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PackageDetailScreen(),
      );
    },
    PaymentResultScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PaymentResultScreenRouteArgs>(
          orElse: () => PaymentResultScreenRouteArgs(
              isSuccess: pathParams.getBool('isSuccess')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PaymentResultScreen(
          key: args.key,
          isSuccess: args.isSuccess,
        ),
      );
    },
    PaymentScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PaymentScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    PorterTrackingMapRoute.name: (routeData) {
      final args = routeData.argsAs<PorterTrackingMapRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PorterTrackingMap(
          key: args.key,
          staffId: args.staffId,
          job: args.job,
          bookingStatus: args.bookingStatus,
        ),
      );
    },
    PorterUploadedImageScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PorterUploadedImageScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PorterUploadedImageScreen(
          key: args.key,
          job: args.job,
        ),
      );
    },
    PrivacyPolicyScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PrivacyPolicyScreenRouteArgs>(
          orElse: () => const PrivacyPolicyScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PrivacyPolicyScreen(key: args.key),
      );
    },
    ProfileDetailScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileDetailScreen(),
      );
    },
    ProfileScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    PromotionDetailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PromotionDetailScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PromotionDetailScreen(
          key: args.key,
          promotion: args.promotion,
        ),
      );
    },
    PromotionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PromotionScreen(),
      );
    },
    RefundScreenRoute.name: (routeData) {
      final args = routeData.argsAs<RefundScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RefundScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    RegistrationSuccessScreenRoute.name: (routeData) {
      final args = routeData.argsAs<RegistrationSuccessScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegistrationSuccessScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    ReviewAtHomeRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewAtHomeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReviewAtHome(
          key: args.key,
          order: args.order,
        ),
      );
    },
    ReviewAtHomeReviewedRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewAtHomeReviewedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReviewAtHomeReviewed(
          key: args.key,
          order: args.order,
          orderOld: args.orderOld,
        ),
      );
    },
    ReviewOnlineRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewOnlineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReviewOnline(
          key: args.key,
          order: args.order,
          orderOld: args.orderOld,
        ),
      );
    },
    ReviewerTrackingMapRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewerTrackingMapRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReviewerTrackingMap(
          key: args.key,
          staffId: args.staffId,
          job: args.job,
          bookingStatus: args.bookingStatus,
        ),
      );
    },
    ServiceScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServiceScreen(),
      );
    },
    SignInScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SignInScreenRouteArgs>(
          orElse: () => const SignInScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignInScreen(key: args.key),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpScreenRouteArgs>(
          orElse: () => const SignUpScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignUpScreen(key: args.key),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    SystemFeeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SystemFeeScreen(),
      );
    },
    TabViewScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabViewScreen(),
      );
    },
    TermOfUseScreenRoute.name: (routeData) {
      final args = routeData.argsAs<TermOfUseScreenRouteArgs>(
          orElse: () => const TermOfUseScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TermOfUseScreen(key: args.key),
      );
    },
    TestCloudinaryScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TestCloudinaryScreen(),
      );
    },
    TestPaymentScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TestPaymentScreen(),
      );
    },
    TimeLineBookingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimeLineBooking(),
      );
    },
    TrackingDriverMapRoute.name: (routeData) {
      final args = routeData.argsAs<TrackingDriverMapRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TrackingDriverMap(
          key: args.key,
          staffId: args.staffId,
          job: args.job,
          bookingStatus: args.bookingStatus,
        ),
      );
    },
    TransactionDetailsOrderRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TransactionDetailsOrder(),
      );
    },
    TransactionOrderResultFailedScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args =
          routeData.argsAs<TransactionOrderResultFailedScreenRouteArgs>(
              orElse: () => TransactionOrderResultFailedScreenRouteArgs(
                    isSuccess: pathParams.getBool('isSuccess'),
                    bookingId: pathParams.getString('bookingId'),
                    allUri: pathParams.getString(''),
                  ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TransactionOrderResultFailedScreen(
          key: args.key,
          isSuccess: args.isSuccess,
          bookingId: args.bookingId,
          allUri: args.allUri,
        ),
      );
    },
    TransactionResultFailedScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TransactionResultFailedScreenRouteArgs>(
          orElse: () => TransactionResultFailedScreenRouteArgs(
                isSuccess: pathParams.getBool('isSuccess'),
                bookingId: pathParams.getString('bookingId'),
                allUri: pathParams.getString(''),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TransactionResultFailedScreen(
          key: args.key,
          isSuccess: args.isSuccess,
          bookingId: args.bookingId,
          allUri: args.allUri,
        ),
      );
    },
    TransactionResultScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TransactionResultScreenRouteArgs>(
          orElse: () => TransactionResultScreenRouteArgs(
                isSuccess: pathParams.getBool('isSuccess'),
                bookingId: pathParams.getString('bookingId'),
                allUri: pathParams.getString(''),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TransactionResultScreen(
          key: args.key,
          isSuccess: args.isSuccess,
          bookingId: args.bookingId,
          allUri: args.allUri,
        ),
      );
    },
    TransactionResultScreenByWalletRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionResultScreenByWalletRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TransactionResultScreenByWallet(
          key: args.key,
          bookingId: args.bookingId,
          status: args.status,
        ),
      );
    },
    TransactionResultScreenRechargeWalletRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args =
          routeData.argsAs<TransactionResultScreenRechargeWalletRouteArgs>(
              orElse: () => TransactionResultScreenRechargeWalletRouteArgs(
                    isSuccess: pathParams.getBool('isSuccess'),
                    allUri: pathParams.getString(''),
                  ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TransactionResultScreenRechargeWallet(
          key: args.key,
          isSuccess: args.isSuccess,
          allUri: args.allUri,
        ),
      );
    },
    VehiclePriceListScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VehiclePriceListScreen(),
      );
    },
    VoucherScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VoucherScreen(),
      );
    },
    WalletScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WalletScreen(),
      );
    },
  };
}

/// generated route for
/// [AvailableVehiclesScreen]
class AvailableVehiclesScreenRoute extends PageRouteInfo<void> {
  const AvailableVehiclesScreenRoute({List<PageRouteInfo>? children})
      : super(
          AvailableVehiclesScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableVehiclesScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BookingScreen]
class BookingScreenRoute extends PageRouteInfo<void> {
  const BookingScreenRoute({List<PageRouteInfo>? children})
      : super(
          BookingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookingScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BookingScreenService]
class BookingScreenServiceRoute extends PageRouteInfo<void> {
  const BookingScreenServiceRoute({List<PageRouteInfo>? children})
      : super(
          BookingScreenServiceRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookingScreenServiceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartVoucherScreen]
class CartVoucherScreenRoute extends PageRouteInfo<void> {
  const CartVoucherScreenRoute({List<PageRouteInfo>? children})
      : super(
          CartVoucherScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartVoucherScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CashPaymentWaiting]
class CashPaymentWaitingRoute
    extends PageRouteInfo<CashPaymentWaitingRouteArgs> {
  CashPaymentWaitingRoute({
    Key? key,
    required int bookingId,
    List<PageRouteInfo>? children,
  }) : super(
          CashPaymentWaitingRoute.name,
          args: CashPaymentWaitingRouteArgs(
            key: key,
            bookingId: bookingId,
          ),
          initialChildren: children,
        );

  static const String name = 'CashPaymentWaitingRoute';

  static const PageInfo<CashPaymentWaitingRouteArgs> page =
      PageInfo<CashPaymentWaitingRouteArgs>(name);
}

class CashPaymentWaitingRouteArgs {
  const CashPaymentWaitingRouteArgs({
    this.key,
    required this.bookingId,
  });

  final Key? key;

  final int bookingId;

  @override
  String toString() {
    return 'CashPaymentWaitingRouteArgs{key: $key, bookingId: $bookingId}';
  }
}

/// generated route for
/// [ChatWithStaffScreen]
class ChatWithStaffScreenRoute
    extends PageRouteInfo<ChatWithStaffScreenRouteArgs> {
  ChatWithStaffScreenRoute({
    Key? key,
    required String staffId,
    required String staffName,
    required StaffRole staffRole,
    required String bookingId,
    required String staffImageAvatar,
    List<PageRouteInfo>? children,
  }) : super(
          ChatWithStaffScreenRoute.name,
          args: ChatWithStaffScreenRouteArgs(
            key: key,
            staffId: staffId,
            staffName: staffName,
            staffRole: staffRole,
            bookingId: bookingId,
            staffImageAvatar: staffImageAvatar,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatWithStaffScreenRoute';

  static const PageInfo<ChatWithStaffScreenRouteArgs> page =
      PageInfo<ChatWithStaffScreenRouteArgs>(name);
}

class ChatWithStaffScreenRouteArgs {
  const ChatWithStaffScreenRouteArgs({
    this.key,
    required this.staffId,
    required this.staffName,
    required this.staffRole,
    required this.bookingId,
    required this.staffImageAvatar,
  });

  final Key? key;

  final String staffId;

  final String staffName;

  final StaffRole staffRole;

  final String bookingId;

  final String staffImageAvatar;

  @override
  String toString() {
    return 'ChatWithStaffScreenRouteArgs{key: $key, staffId: $staffId, staffName: $staffName, staffRole: $staffRole, bookingId: $bookingId, staffImageAvatar: $staffImageAvatar}';
  }
}

/// generated route for
/// [CleaningServiceScreen]
class CleaningServiceScreenRoute extends PageRouteInfo<void> {
  const CleaningServiceScreenRoute({List<PageRouteInfo>? children})
      : super(
          CleaningServiceScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CleaningServiceScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CombinedWalletStatisticsScreen]
class CombinedWalletStatisticsScreenRoute extends PageRouteInfo<void> {
  const CombinedWalletStatisticsScreenRoute({List<PageRouteInfo>? children})
      : super(
          CombinedWalletStatisticsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CombinedWalletStatisticsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ConfirmLastPayment]
class ConfirmLastPaymentRoute
    extends PageRouteInfo<ConfirmLastPaymentRouteArgs> {
  ConfirmLastPaymentRoute({
    Key? key,
    required OrderEntity? orderObj,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          ConfirmLastPaymentRoute.name,
          args: ConfirmLastPaymentRouteArgs(
            key: key,
            orderObj: orderObj,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmLastPaymentRoute';

  static const PageInfo<ConfirmLastPaymentRouteArgs> page =
      PageInfo<ConfirmLastPaymentRouteArgs>(name);
}

class ConfirmLastPaymentRouteArgs {
  const ConfirmLastPaymentRouteArgs({
    this.key,
    required this.orderObj,
    required this.id,
  });

  final Key? key;

  final OrderEntity? orderObj;

  final int id;

  @override
  String toString() {
    return 'ConfirmLastPaymentRouteArgs{key: $key, orderObj: $orderObj, id: $id}';
  }
}

/// generated route for
/// [ConfirmServiceBookingScreen]
class ConfirmServiceBookingScreenRoute
    extends PageRouteInfo<ConfirmServiceBookingScreenRouteArgs> {
  ConfirmServiceBookingScreenRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          ConfirmServiceBookingScreenRoute.name,
          args: ConfirmServiceBookingScreenRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmServiceBookingScreenRoute';

  static const PageInfo<ConfirmServiceBookingScreenRouteArgs> page =
      PageInfo<ConfirmServiceBookingScreenRouteArgs>(name);
}

class ConfirmServiceBookingScreenRouteArgs {
  const ConfirmServiceBookingScreenRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'ConfirmServiceBookingScreenRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [ContactScreen]
class ContactScreenRoute extends PageRouteInfo<void> {
  const ContactScreenRoute({List<PageRouteInfo>? children})
      : super(
          ContactScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CouponDetailScreen]
class CouponDetailScreenRoute
    extends PageRouteInfo<CouponDetailScreenRouteArgs> {
  CouponDetailScreenRoute({
    Key? key,
    required PromotionEntity promotion,
    List<PageRouteInfo>? children,
  }) : super(
          CouponDetailScreenRoute.name,
          args: CouponDetailScreenRouteArgs(
            key: key,
            promotion: promotion,
          ),
          initialChildren: children,
        );

  static const String name = 'CouponDetailScreenRoute';

  static const PageInfo<CouponDetailScreenRouteArgs> page =
      PageInfo<CouponDetailScreenRouteArgs>(name);
}

class CouponDetailScreenRouteArgs {
  const CouponDetailScreenRouteArgs({
    this.key,
    required this.promotion,
  });

  final Key? key;

  final PromotionEntity promotion;

  @override
  String toString() {
    return 'CouponDetailScreenRouteArgs{key: $key, promotion: $promotion}';
  }
}

/// generated route for
/// [DriverUploadedImageScreen]
class DriverUploadedImageScreenRoute
    extends PageRouteInfo<DriverUploadedImageScreenRouteArgs> {
  DriverUploadedImageScreenRoute({
    Key? key,
    required OrderEntity job,
    List<PageRouteInfo>? children,
  }) : super(
          DriverUploadedImageScreenRoute.name,
          args: DriverUploadedImageScreenRouteArgs(
            key: key,
            job: job,
          ),
          initialChildren: children,
        );

  static const String name = 'DriverUploadedImageScreenRoute';

  static const PageInfo<DriverUploadedImageScreenRouteArgs> page =
      PageInfo<DriverUploadedImageScreenRouteArgs>(name);
}

class DriverUploadedImageScreenRouteArgs {
  const DriverUploadedImageScreenRouteArgs({
    this.key,
    required this.job,
  });

  final Key? key;

  final OrderEntity job;

  @override
  String toString() {
    return 'DriverUploadedImageScreenRouteArgs{key: $key, job: $job}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute({List<PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IncidentDetailsScreen]
class IncidentDetailsScreenRoute
    extends PageRouteInfo<IncidentDetailsScreenRouteArgs> {
  IncidentDetailsScreenRoute({
    Key? key,
    required BookingTrackersIncidentEntity incident,
    List<PageRouteInfo>? children,
  }) : super(
          IncidentDetailsScreenRoute.name,
          args: IncidentDetailsScreenRouteArgs(
            key: key,
            incident: incident,
          ),
          initialChildren: children,
        );

  static const String name = 'IncidentDetailsScreenRoute';

  static const PageInfo<IncidentDetailsScreenRouteArgs> page =
      PageInfo<IncidentDetailsScreenRouteArgs>(name);
}

class IncidentDetailsScreenRouteArgs {
  const IncidentDetailsScreenRouteArgs({
    this.key,
    required this.incident,
  });

  final Key? key;

  final BookingTrackersIncidentEntity incident;

  @override
  String toString() {
    return 'IncidentDetailsScreenRouteArgs{key: $key, incident: $incident}';
  }
}

/// generated route for
/// [IncidentsListScreen]
class IncidentsListScreenRoute extends PageRouteInfo<void> {
  const IncidentsListScreenRoute({List<PageRouteInfo>? children})
      : super(
          IncidentsListScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'IncidentsListScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IncidentsScreen]
class IncidentsScreenRoute extends PageRouteInfo<IncidentsScreenRouteArgs> {
  IncidentsScreenRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          IncidentsScreenRoute.name,
          args: IncidentsScreenRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'IncidentsScreenRoute';

  static const PageInfo<IncidentsScreenRouteArgs> page =
      PageInfo<IncidentsScreenRouteArgs>(name);
}

class IncidentsScreenRouteArgs {
  const IncidentsScreenRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'IncidentsScreenRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [InfoScreen]
class InfoScreenRoute extends PageRouteInfo<void> {
  const InfoScreenRoute({List<PageRouteInfo>? children})
      : super(
          InfoScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'InfoScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LastPaymentScreen]
class LastPaymentScreenRoute extends PageRouteInfo<LastPaymentScreenRouteArgs> {
  LastPaymentScreenRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          LastPaymentScreenRoute.name,
          args: LastPaymentScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'LastPaymentScreenRoute';

  static const PageInfo<LastPaymentScreenRouteArgs> page =
      PageInfo<LastPaymentScreenRouteArgs>(name);
}

class LastPaymentScreenRouteArgs {
  const LastPaymentScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'LastPaymentScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [LastTransactionResultCashPayment]
class LastTransactionResultCashPaymentRoute
    extends PageRouteInfo<LastTransactionResultCashPaymentRouteArgs> {
  LastTransactionResultCashPaymentRoute({
    Key? key,
    required OrderEntity? order,
    bool? status,
    List<PageRouteInfo>? children,
  }) : super(
          LastTransactionResultCashPaymentRoute.name,
          args: LastTransactionResultCashPaymentRouteArgs(
            key: key,
            order: order,
            status: status,
          ),
          initialChildren: children,
        );

  static const String name = 'LastTransactionResultCashPaymentRoute';

  static const PageInfo<LastTransactionResultCashPaymentRouteArgs> page =
      PageInfo<LastTransactionResultCashPaymentRouteArgs>(name);
}

class LastTransactionResultCashPaymentRouteArgs {
  const LastTransactionResultCashPaymentRouteArgs({
    this.key,
    required this.order,
    this.status,
  });

  final Key? key;

  final OrderEntity? order;

  final bool? status;

  @override
  String toString() {
    return 'LastTransactionResultCashPaymentRouteArgs{key: $key, order: $order, status: $status}';
  }
}

/// generated route for
/// [LastTransactionResultScreen]
class LastTransactionResultScreenRoute
    extends PageRouteInfo<LastTransactionResultScreenRouteArgs> {
  LastTransactionResultScreenRoute({
    Key? key,
    required bool isSuccess,
    required String bookingId,
    required String allUri,
    List<PageRouteInfo>? children,
  }) : super(
          LastTransactionResultScreenRoute.name,
          args: LastTransactionResultScreenRouteArgs(
            key: key,
            isSuccess: isSuccess,
            bookingId: bookingId,
            allUri: allUri,
          ),
          rawPathParams: {
            'isSuccess': isSuccess,
            'bookingId': bookingId,
            '': allUri,
          },
          initialChildren: children,
        );

  static const String name = 'LastTransactionResultScreenRoute';

  static const PageInfo<LastTransactionResultScreenRouteArgs> page =
      PageInfo<LastTransactionResultScreenRouteArgs>(name);
}

class LastTransactionResultScreenRouteArgs {
  const LastTransactionResultScreenRouteArgs({
    this.key,
    required this.isSuccess,
    required this.bookingId,
    required this.allUri,
  });

  final Key? key;

  final bool isSuccess;

  final String bookingId;

  final String allUri;

  @override
  String toString() {
    return 'LastTransactionResultScreenRouteArgs{key: $key, isSuccess: $isSuccess, bookingId: $bookingId, allUri: $allUri}';
  }
}

/// generated route for
/// [LastTransactionResultScreenByWallet]
class LastTransactionResultScreenByWalletRoute
    extends PageRouteInfo<LastTransactionResultScreenByWalletRouteArgs> {
  LastTransactionResultScreenByWalletRoute({
    Key? key,
    required int bookingId,
    bool? status,
    List<PageRouteInfo>? children,
  }) : super(
          LastTransactionResultScreenByWalletRoute.name,
          args: LastTransactionResultScreenByWalletRouteArgs(
            key: key,
            bookingId: bookingId,
            status: status,
          ),
          initialChildren: children,
        );

  static const String name = 'LastTransactionResultScreenByWalletRoute';

  static const PageInfo<LastTransactionResultScreenByWalletRouteArgs> page =
      PageInfo<LastTransactionResultScreenByWalletRouteArgs>(name);
}

class LastTransactionResultScreenByWalletRouteArgs {
  const LastTransactionResultScreenByWalletRouteArgs({
    this.key,
    required this.bookingId,
    this.status,
  });

  final Key? key;

  final int bookingId;

  final bool? status;

  @override
  String toString() {
    return 'LastTransactionResultScreenByWalletRouteArgs{key: $key, bookingId: $bookingId, status: $status}';
  }
}

/// generated route for
/// [ListTransactionScreen]
class ListTransactionScreenRoute extends PageRouteInfo<void> {
  const ListTransactionScreenRoute({List<PageRouteInfo>? children})
      : super(
          ListTransactionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ListTransactionScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoadingScreen]
class LoadingScreenRoute extends PageRouteInfo<void> {
  const LoadingScreenRoute({List<PageRouteInfo>? children})
      : super(
          LoadingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LocationSelectionScreen]
class LocationSelectionScreenRoute extends PageRouteInfo<void> {
  const LocationSelectionScreenRoute({List<PageRouteInfo>? children})
      : super(
          LocationSelectionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocationSelectionScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapScreenTest]
class MapScreenTestRoute extends PageRouteInfo<void> {
  const MapScreenTestRoute({List<PageRouteInfo>? children})
      : super(
          MapScreenTestRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapScreenTestRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationExceptScreen]
class NotificationExceptScreenRoute extends PageRouteInfo<void> {
  const NotificationExceptScreenRoute({List<PageRouteInfo>? children})
      : super(
          NotificationExceptScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationExceptScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OTPVerificationScreen]
class OTPVerificationScreenRoute
    extends PageRouteInfo<OTPVerificationScreenRouteArgs> {
  OTPVerificationScreenRoute({
    Key? key,
    required String phoneNumber,
    required VerificationOTPType verifyType,
    List<PageRouteInfo>? children,
  }) : super(
          OTPVerificationScreenRoute.name,
          args: OTPVerificationScreenRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            verifyType: verifyType,
          ),
          initialChildren: children,
        );

  static const String name = 'OTPVerificationScreenRoute';

  static const PageInfo<OTPVerificationScreenRouteArgs> page =
      PageInfo<OTPVerificationScreenRouteArgs>(name);
}

class OTPVerificationScreenRouteArgs {
  const OTPVerificationScreenRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.verifyType,
  });

  final Key? key;

  final String phoneNumber;

  final VerificationOTPType verifyType;

  @override
  String toString() {
    return 'OTPVerificationScreenRouteArgs{key: $key, phoneNumber: $phoneNumber, verifyType: $verifyType}';
  }
}

/// generated route for
/// [OnboardingScreen]
class OnboardingScreenRoute extends PageRouteInfo<OnboardingScreenRouteArgs> {
  OnboardingScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OnboardingScreenRoute.name,
          args: OnboardingScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static const PageInfo<OnboardingScreenRouteArgs> page =
      PageInfo<OnboardingScreenRouteArgs>(name);
}

class OnboardingScreenRouteArgs {
  const OnboardingScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OnboardingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OrderDetailsScreen]
class OrderDetailsScreenRoute
    extends PageRouteInfo<OrderDetailsScreenRouteArgs> {
  OrderDetailsScreenRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          OrderDetailsScreenRoute.name,
          args: OrderDetailsScreenRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailsScreenRoute';

  static const PageInfo<OrderDetailsScreenRouteArgs> page =
      PageInfo<OrderDetailsScreenRouteArgs>(name);
}

class OrderDetailsScreenRouteArgs {
  const OrderDetailsScreenRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'OrderDetailsScreenRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [OrderScreen]
class OrderScreenRoute extends PageRouteInfo<void> {
  const OrderScreenRoute({List<PageRouteInfo>? children})
      : super(
          OrderScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PackageDetailScreen]
class PackageDetailScreenRoute extends PageRouteInfo<void> {
  const PackageDetailScreenRoute({List<PageRouteInfo>? children})
      : super(
          PackageDetailScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PackageDetailScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PaymentResultScreen]
class PaymentResultScreenRoute
    extends PageRouteInfo<PaymentResultScreenRouteArgs> {
  PaymentResultScreenRoute({
    Key? key,
    required bool isSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentResultScreenRoute.name,
          args: PaymentResultScreenRouteArgs(
            key: key,
            isSuccess: isSuccess,
          ),
          rawPathParams: {'isSuccess': isSuccess},
          initialChildren: children,
        );

  static const String name = 'PaymentResultScreenRoute';

  static const PageInfo<PaymentResultScreenRouteArgs> page =
      PageInfo<PaymentResultScreenRouteArgs>(name);
}

class PaymentResultScreenRouteArgs {
  const PaymentResultScreenRouteArgs({
    this.key,
    required this.isSuccess,
  });

  final Key? key;

  final bool isSuccess;

  @override
  String toString() {
    return 'PaymentResultScreenRouteArgs{key: $key, isSuccess: $isSuccess}';
  }
}

/// generated route for
/// [PaymentScreen]
class PaymentScreenRoute extends PageRouteInfo<PaymentScreenRouteArgs> {
  PaymentScreenRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentScreenRoute.name,
          args: PaymentScreenRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentScreenRoute';

  static const PageInfo<PaymentScreenRouteArgs> page =
      PageInfo<PaymentScreenRouteArgs>(name);
}

class PaymentScreenRouteArgs {
  const PaymentScreenRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'PaymentScreenRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [PorterTrackingMap]
class PorterTrackingMapRoute extends PageRouteInfo<PorterTrackingMapRouteArgs> {
  PorterTrackingMapRoute({
    Key? key,
    required String staffId,
    required OrderEntity job,
    required BookingStatusResult bookingStatus,
    List<PageRouteInfo>? children,
  }) : super(
          PorterTrackingMapRoute.name,
          args: PorterTrackingMapRouteArgs(
            key: key,
            staffId: staffId,
            job: job,
            bookingStatus: bookingStatus,
          ),
          initialChildren: children,
        );

  static const String name = 'PorterTrackingMapRoute';

  static const PageInfo<PorterTrackingMapRouteArgs> page =
      PageInfo<PorterTrackingMapRouteArgs>(name);
}

class PorterTrackingMapRouteArgs {
  const PorterTrackingMapRouteArgs({
    this.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  final Key? key;

  final String staffId;

  final OrderEntity job;

  final BookingStatusResult bookingStatus;

  @override
  String toString() {
    return 'PorterTrackingMapRouteArgs{key: $key, staffId: $staffId, job: $job, bookingStatus: $bookingStatus}';
  }
}

/// generated route for
/// [PorterUploadedImageScreen]
class PorterUploadedImageScreenRoute
    extends PageRouteInfo<PorterUploadedImageScreenRouteArgs> {
  PorterUploadedImageScreenRoute({
    Key? key,
    required OrderEntity job,
    List<PageRouteInfo>? children,
  }) : super(
          PorterUploadedImageScreenRoute.name,
          args: PorterUploadedImageScreenRouteArgs(
            key: key,
            job: job,
          ),
          initialChildren: children,
        );

  static const String name = 'PorterUploadedImageScreenRoute';

  static const PageInfo<PorterUploadedImageScreenRouteArgs> page =
      PageInfo<PorterUploadedImageScreenRouteArgs>(name);
}

class PorterUploadedImageScreenRouteArgs {
  const PorterUploadedImageScreenRouteArgs({
    this.key,
    required this.job,
  });

  final Key? key;

  final OrderEntity job;

  @override
  String toString() {
    return 'PorterUploadedImageScreenRouteArgs{key: $key, job: $job}';
  }
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyScreenRoute
    extends PageRouteInfo<PrivacyPolicyScreenRouteArgs> {
  PrivacyPolicyScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PrivacyPolicyScreenRoute.name,
          args: PrivacyPolicyScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyScreenRoute';

  static const PageInfo<PrivacyPolicyScreenRouteArgs> page =
      PageInfo<PrivacyPolicyScreenRouteArgs>(name);
}

class PrivacyPolicyScreenRouteArgs {
  const PrivacyPolicyScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PrivacyPolicyScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ProfileDetailScreen]
class ProfileDetailScreenRoute extends PageRouteInfo<void> {
  const ProfileDetailScreenRoute({List<PageRouteInfo>? children})
      : super(
          ProfileDetailScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileDetailScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileScreenRoute extends PageRouteInfo<void> {
  const ProfileScreenRoute({List<PageRouteInfo>? children})
      : super(
          ProfileScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PromotionDetailScreen]
class PromotionDetailScreenRoute
    extends PageRouteInfo<PromotionDetailScreenRouteArgs> {
  PromotionDetailScreenRoute({
    Key? key,
    required PromotionEntity promotion,
    List<PageRouteInfo>? children,
  }) : super(
          PromotionDetailScreenRoute.name,
          args: PromotionDetailScreenRouteArgs(
            key: key,
            promotion: promotion,
          ),
          initialChildren: children,
        );

  static const String name = 'PromotionDetailScreenRoute';

  static const PageInfo<PromotionDetailScreenRouteArgs> page =
      PageInfo<PromotionDetailScreenRouteArgs>(name);
}

class PromotionDetailScreenRouteArgs {
  const PromotionDetailScreenRouteArgs({
    this.key,
    required this.promotion,
  });

  final Key? key;

  final PromotionEntity promotion;

  @override
  String toString() {
    return 'PromotionDetailScreenRouteArgs{key: $key, promotion: $promotion}';
  }
}

/// generated route for
/// [PromotionScreen]
class PromotionScreenRoute extends PageRouteInfo<void> {
  const PromotionScreenRoute({List<PageRouteInfo>? children})
      : super(
          PromotionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PromotionScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RefundScreen]
class RefundScreenRoute extends PageRouteInfo<RefundScreenRouteArgs> {
  RefundScreenRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          RefundScreenRoute.name,
          args: RefundScreenRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'RefundScreenRoute';

  static const PageInfo<RefundScreenRouteArgs> page =
      PageInfo<RefundScreenRouteArgs>(name);
}

class RefundScreenRouteArgs {
  const RefundScreenRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'RefundScreenRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [RegistrationSuccessScreen]
class RegistrationSuccessScreenRoute
    extends PageRouteInfo<RegistrationSuccessScreenRouteArgs> {
  RegistrationSuccessScreenRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          RegistrationSuccessScreenRoute.name,
          args: RegistrationSuccessScreenRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'RegistrationSuccessScreenRoute';

  static const PageInfo<RegistrationSuccessScreenRouteArgs> page =
      PageInfo<RegistrationSuccessScreenRouteArgs>(name);
}

class RegistrationSuccessScreenRouteArgs {
  const RegistrationSuccessScreenRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'RegistrationSuccessScreenRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [ReviewAtHome]
class ReviewAtHomeRoute extends PageRouteInfo<ReviewAtHomeRouteArgs> {
  ReviewAtHomeRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          ReviewAtHomeRoute.name,
          args: ReviewAtHomeRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'ReviewAtHomeRoute';

  static const PageInfo<ReviewAtHomeRouteArgs> page =
      PageInfo<ReviewAtHomeRouteArgs>(name);
}

class ReviewAtHomeRouteArgs {
  const ReviewAtHomeRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'ReviewAtHomeRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [ReviewAtHomeReviewed]
class ReviewAtHomeReviewedRoute
    extends PageRouteInfo<ReviewAtHomeReviewedRouteArgs> {
  ReviewAtHomeReviewedRoute({
    Key? key,
    required OrderEntity order,
    required OrderEntity? orderOld,
    List<PageRouteInfo>? children,
  }) : super(
          ReviewAtHomeReviewedRoute.name,
          args: ReviewAtHomeReviewedRouteArgs(
            key: key,
            order: order,
            orderOld: orderOld,
          ),
          initialChildren: children,
        );

  static const String name = 'ReviewAtHomeReviewedRoute';

  static const PageInfo<ReviewAtHomeReviewedRouteArgs> page =
      PageInfo<ReviewAtHomeReviewedRouteArgs>(name);
}

class ReviewAtHomeReviewedRouteArgs {
  const ReviewAtHomeReviewedRouteArgs({
    this.key,
    required this.order,
    required this.orderOld,
  });

  final Key? key;

  final OrderEntity order;

  final OrderEntity? orderOld;

  @override
  String toString() {
    return 'ReviewAtHomeReviewedRouteArgs{key: $key, order: $order, orderOld: $orderOld}';
  }
}

/// generated route for
/// [ReviewOnline]
class ReviewOnlineRoute extends PageRouteInfo<ReviewOnlineRouteArgs> {
  ReviewOnlineRoute({
    Key? key,
    required OrderEntity order,
    required OrderEntity? orderOld,
    List<PageRouteInfo>? children,
  }) : super(
          ReviewOnlineRoute.name,
          args: ReviewOnlineRouteArgs(
            key: key,
            order: order,
            orderOld: orderOld,
          ),
          initialChildren: children,
        );

  static const String name = 'ReviewOnlineRoute';

  static const PageInfo<ReviewOnlineRouteArgs> page =
      PageInfo<ReviewOnlineRouteArgs>(name);
}

class ReviewOnlineRouteArgs {
  const ReviewOnlineRouteArgs({
    this.key,
    required this.order,
    required this.orderOld,
  });

  final Key? key;

  final OrderEntity order;

  final OrderEntity? orderOld;

  @override
  String toString() {
    return 'ReviewOnlineRouteArgs{key: $key, order: $order, orderOld: $orderOld}';
  }
}

/// generated route for
/// [ReviewerTrackingMap]
class ReviewerTrackingMapRoute
    extends PageRouteInfo<ReviewerTrackingMapRouteArgs> {
  ReviewerTrackingMapRoute({
    Key? key,
    required String staffId,
    required OrderEntity job,
    required BookingStatusResult bookingStatus,
    List<PageRouteInfo>? children,
  }) : super(
          ReviewerTrackingMapRoute.name,
          args: ReviewerTrackingMapRouteArgs(
            key: key,
            staffId: staffId,
            job: job,
            bookingStatus: bookingStatus,
          ),
          initialChildren: children,
        );

  static const String name = 'ReviewerTrackingMapRoute';

  static const PageInfo<ReviewerTrackingMapRouteArgs> page =
      PageInfo<ReviewerTrackingMapRouteArgs>(name);
}

class ReviewerTrackingMapRouteArgs {
  const ReviewerTrackingMapRouteArgs({
    this.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  final Key? key;

  final String staffId;

  final OrderEntity job;

  final BookingStatusResult bookingStatus;

  @override
  String toString() {
    return 'ReviewerTrackingMapRouteArgs{key: $key, staffId: $staffId, job: $job, bookingStatus: $bookingStatus}';
  }
}

/// generated route for
/// [ServiceScreen]
class ServiceScreenRoute extends PageRouteInfo<void> {
  const ServiceScreenRoute({List<PageRouteInfo>? children})
      : super(
          ServiceScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServiceScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignInScreen]
class SignInScreenRoute extends PageRouteInfo<SignInScreenRouteArgs> {
  SignInScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SignInScreenRoute.name,
          args: SignInScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SignInScreenRoute';

  static const PageInfo<SignInScreenRouteArgs> page =
      PageInfo<SignInScreenRouteArgs>(name);
}

class SignInScreenRouteArgs {
  const SignInScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SignInScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SignUpScreen]
class SignUpScreenRoute extends PageRouteInfo<SignUpScreenRouteArgs> {
  SignUpScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SignUpScreenRoute.name,
          args: SignUpScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SignUpScreenRoute';

  static const PageInfo<SignUpScreenRouteArgs> page =
      PageInfo<SignUpScreenRouteArgs>(name);
}

class SignUpScreenRouteArgs {
  const SignUpScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SignUpScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SystemFeeScreen]
class SystemFeeScreenRoute extends PageRouteInfo<void> {
  const SystemFeeScreenRoute({List<PageRouteInfo>? children})
      : super(
          SystemFeeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SystemFeeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabViewScreen]
class TabViewScreenRoute extends PageRouteInfo<void> {
  const TabViewScreenRoute({List<PageRouteInfo>? children})
      : super(
          TabViewScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabViewScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TermOfUseScreen]
class TermOfUseScreenRoute extends PageRouteInfo<TermOfUseScreenRouteArgs> {
  TermOfUseScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          TermOfUseScreenRoute.name,
          args: TermOfUseScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'TermOfUseScreenRoute';

  static const PageInfo<TermOfUseScreenRouteArgs> page =
      PageInfo<TermOfUseScreenRouteArgs>(name);
}

class TermOfUseScreenRouteArgs {
  const TermOfUseScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'TermOfUseScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [TestCloudinaryScreen]
class TestCloudinaryScreenRoute extends PageRouteInfo<void> {
  const TestCloudinaryScreenRoute({List<PageRouteInfo>? children})
      : super(
          TestCloudinaryScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TestCloudinaryScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TestPaymentScreen]
class TestPaymentScreenRoute extends PageRouteInfo<void> {
  const TestPaymentScreenRoute({List<PageRouteInfo>? children})
      : super(
          TestPaymentScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TestPaymentScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimeLineBooking]
class TimeLineBookingRoute extends PageRouteInfo<void> {
  const TimeLineBookingRoute({List<PageRouteInfo>? children})
      : super(
          TimeLineBookingRoute.name,
          initialChildren: children,
        );

  static const String name = 'TimeLineBookingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrackingDriverMap]
class TrackingDriverMapRoute extends PageRouteInfo<TrackingDriverMapRouteArgs> {
  TrackingDriverMapRoute({
    Key? key,
    required String staffId,
    required OrderEntity job,
    required BookingStatusResult bookingStatus,
    List<PageRouteInfo>? children,
  }) : super(
          TrackingDriverMapRoute.name,
          args: TrackingDriverMapRouteArgs(
            key: key,
            staffId: staffId,
            job: job,
            bookingStatus: bookingStatus,
          ),
          initialChildren: children,
        );

  static const String name = 'TrackingDriverMapRoute';

  static const PageInfo<TrackingDriverMapRouteArgs> page =
      PageInfo<TrackingDriverMapRouteArgs>(name);
}

class TrackingDriverMapRouteArgs {
  const TrackingDriverMapRouteArgs({
    this.key,
    required this.staffId,
    required this.job,
    required this.bookingStatus,
  });

  final Key? key;

  final String staffId;

  final OrderEntity job;

  final BookingStatusResult bookingStatus;

  @override
  String toString() {
    return 'TrackingDriverMapRouteArgs{key: $key, staffId: $staffId, job: $job, bookingStatus: $bookingStatus}';
  }
}

/// generated route for
/// [TransactionDetailsOrder]
class TransactionDetailsOrderRoute extends PageRouteInfo<void> {
  const TransactionDetailsOrderRoute({List<PageRouteInfo>? children})
      : super(
          TransactionDetailsOrderRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionDetailsOrderRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TransactionOrderResultFailedScreen]
class TransactionOrderResultFailedScreenRoute
    extends PageRouteInfo<TransactionOrderResultFailedScreenRouteArgs> {
  TransactionOrderResultFailedScreenRoute({
    Key? key,
    required bool isSuccess,
    required String bookingId,
    required String allUri,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionOrderResultFailedScreenRoute.name,
          args: TransactionOrderResultFailedScreenRouteArgs(
            key: key,
            isSuccess: isSuccess,
            bookingId: bookingId,
            allUri: allUri,
          ),
          rawPathParams: {
            'isSuccess': isSuccess,
            'bookingId': bookingId,
            '': allUri,
          },
          initialChildren: children,
        );

  static const String name = 'TransactionOrderResultFailedScreenRoute';

  static const PageInfo<TransactionOrderResultFailedScreenRouteArgs> page =
      PageInfo<TransactionOrderResultFailedScreenRouteArgs>(name);
}

class TransactionOrderResultFailedScreenRouteArgs {
  const TransactionOrderResultFailedScreenRouteArgs({
    this.key,
    required this.isSuccess,
    required this.bookingId,
    required this.allUri,
  });

  final Key? key;

  final bool isSuccess;

  final String bookingId;

  final String allUri;

  @override
  String toString() {
    return 'TransactionOrderResultFailedScreenRouteArgs{key: $key, isSuccess: $isSuccess, bookingId: $bookingId, allUri: $allUri}';
  }
}

/// generated route for
/// [TransactionResultFailedScreen]
class TransactionResultFailedScreenRoute
    extends PageRouteInfo<TransactionResultFailedScreenRouteArgs> {
  TransactionResultFailedScreenRoute({
    Key? key,
    required bool isSuccess,
    required String bookingId,
    required String allUri,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionResultFailedScreenRoute.name,
          args: TransactionResultFailedScreenRouteArgs(
            key: key,
            isSuccess: isSuccess,
            bookingId: bookingId,
            allUri: allUri,
          ),
          rawPathParams: {
            'isSuccess': isSuccess,
            'bookingId': bookingId,
            '': allUri,
          },
          initialChildren: children,
        );

  static const String name = 'TransactionResultFailedScreenRoute';

  static const PageInfo<TransactionResultFailedScreenRouteArgs> page =
      PageInfo<TransactionResultFailedScreenRouteArgs>(name);
}

class TransactionResultFailedScreenRouteArgs {
  const TransactionResultFailedScreenRouteArgs({
    this.key,
    required this.isSuccess,
    required this.bookingId,
    required this.allUri,
  });

  final Key? key;

  final bool isSuccess;

  final String bookingId;

  final String allUri;

  @override
  String toString() {
    return 'TransactionResultFailedScreenRouteArgs{key: $key, isSuccess: $isSuccess, bookingId: $bookingId, allUri: $allUri}';
  }
}

/// generated route for
/// [TransactionResultScreen]
class TransactionResultScreenRoute
    extends PageRouteInfo<TransactionResultScreenRouteArgs> {
  TransactionResultScreenRoute({
    Key? key,
    required bool isSuccess,
    required String bookingId,
    required String allUri,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionResultScreenRoute.name,
          args: TransactionResultScreenRouteArgs(
            key: key,
            isSuccess: isSuccess,
            bookingId: bookingId,
            allUri: allUri,
          ),
          rawPathParams: {
            'isSuccess': isSuccess,
            'bookingId': bookingId,
            '': allUri,
          },
          initialChildren: children,
        );

  static const String name = 'TransactionResultScreenRoute';

  static const PageInfo<TransactionResultScreenRouteArgs> page =
      PageInfo<TransactionResultScreenRouteArgs>(name);
}

class TransactionResultScreenRouteArgs {
  const TransactionResultScreenRouteArgs({
    this.key,
    required this.isSuccess,
    required this.bookingId,
    required this.allUri,
  });

  final Key? key;

  final bool isSuccess;

  final String bookingId;

  final String allUri;

  @override
  String toString() {
    return 'TransactionResultScreenRouteArgs{key: $key, isSuccess: $isSuccess, bookingId: $bookingId, allUri: $allUri}';
  }
}

/// generated route for
/// [TransactionResultScreenByWallet]
class TransactionResultScreenByWalletRoute
    extends PageRouteInfo<TransactionResultScreenByWalletRouteArgs> {
  TransactionResultScreenByWalletRoute({
    Key? key,
    required int bookingId,
    bool? status,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionResultScreenByWalletRoute.name,
          args: TransactionResultScreenByWalletRouteArgs(
            key: key,
            bookingId: bookingId,
            status: status,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionResultScreenByWalletRoute';

  static const PageInfo<TransactionResultScreenByWalletRouteArgs> page =
      PageInfo<TransactionResultScreenByWalletRouteArgs>(name);
}

class TransactionResultScreenByWalletRouteArgs {
  const TransactionResultScreenByWalletRouteArgs({
    this.key,
    required this.bookingId,
    this.status,
  });

  final Key? key;

  final int bookingId;

  final bool? status;

  @override
  String toString() {
    return 'TransactionResultScreenByWalletRouteArgs{key: $key, bookingId: $bookingId, status: $status}';
  }
}

/// generated route for
/// [TransactionResultScreenRechargeWallet]
class TransactionResultScreenRechargeWalletRoute
    extends PageRouteInfo<TransactionResultScreenRechargeWalletRouteArgs> {
  TransactionResultScreenRechargeWalletRoute({
    Key? key,
    required bool isSuccess,
    required String allUri,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionResultScreenRechargeWalletRoute.name,
          args: TransactionResultScreenRechargeWalletRouteArgs(
            key: key,
            isSuccess: isSuccess,
            allUri: allUri,
          ),
          rawPathParams: {
            'isSuccess': isSuccess,
            '': allUri,
          },
          initialChildren: children,
        );

  static const String name = 'TransactionResultScreenRechargeWalletRoute';

  static const PageInfo<TransactionResultScreenRechargeWalletRouteArgs> page =
      PageInfo<TransactionResultScreenRechargeWalletRouteArgs>(name);
}

class TransactionResultScreenRechargeWalletRouteArgs {
  const TransactionResultScreenRechargeWalletRouteArgs({
    this.key,
    required this.isSuccess,
    required this.allUri,
  });

  final Key? key;

  final bool isSuccess;

  final String allUri;

  @override
  String toString() {
    return 'TransactionResultScreenRechargeWalletRouteArgs{key: $key, isSuccess: $isSuccess, allUri: $allUri}';
  }
}

/// generated route for
/// [VehiclePriceListScreen]
class VehiclePriceListScreenRoute extends PageRouteInfo<void> {
  const VehiclePriceListScreenRoute({List<PageRouteInfo>? children})
      : super(
          VehiclePriceListScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'VehiclePriceListScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [VoucherScreen]
class VoucherScreenRoute extends PageRouteInfo<void> {
  const VoucherScreenRoute({List<PageRouteInfo>? children})
      : super(
          VoucherScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'VoucherScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WalletScreen]
class WalletScreenRoute extends PageRouteInfo<void> {
  const WalletScreenRoute({List<PageRouteInfo>? children})
      : super(
          WalletScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'WalletScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
