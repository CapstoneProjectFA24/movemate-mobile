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
    CleaningServiceScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CleaningServiceScreen(),
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
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    InfoScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InfoScreen(),
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
    ReviewOnlineRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewOnlineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReviewOnline(
          key: args.key,
          order: args.order,
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
          isSuccess: args.isSuccess,
          bookingId: args.bookingId,
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
    required PromotionModel promotion,
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

  final PromotionModel promotion;

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
/// [ReviewOnline]
class ReviewOnlineRoute extends PageRouteInfo<ReviewOnlineRouteArgs> {
  ReviewOnlineRoute({
    Key? key,
    required OrderEntity order,
    List<PageRouteInfo>? children,
  }) : super(
          ReviewOnlineRoute.name,
          args: ReviewOnlineRouteArgs(
            key: key,
            order: order,
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
  });

  final Key? key;

  final OrderEntity order;

  @override
  String toString() {
    return 'ReviewOnlineRouteArgs{key: $key, order: $order}';
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
    required bool isSuccess,
    required String bookingId,
    List<PageRouteInfo>? children,
  }) : super(
          TransactionResultScreenByWalletRoute.name,
          args: TransactionResultScreenByWalletRouteArgs(
            key: key,
            isSuccess: isSuccess,
            bookingId: bookingId,
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
    required this.isSuccess,
    required this.bookingId,
  });

  final Key? key;

  final bool isSuccess;

  final String bookingId;

  @override
  String toString() {
    return 'TransactionResultScreenByWalletRouteArgs{key: $key, isSuccess: $isSuccess, bookingId: $bookingId}';
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
