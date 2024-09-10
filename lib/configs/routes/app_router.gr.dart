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
      final args = routeData.argsAs<AvailableVehiclesScreenRouteArgs>(
          orElse: () => const AvailableVehiclesScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AvailableVehiclesScreen(
          key: args.key,
          avalble: args.avalble,
        ),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
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
    OrderScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderScreen(),
      );
    },
    OrderSelectPackageScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderSelectPackageScreen(),
      );
    },
    PackageDetailScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PackageDetailScreen(),
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
    TabViewScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabViewScreen(),
      );
    },
  };
}

/// generated route for
/// [AvailableVehiclesScreen]
class AvailableVehiclesScreenRoute
    extends PageRouteInfo<AvailableVehiclesScreenRouteArgs> {
  AvailableVehiclesScreenRoute({
    Key? key,
    AvailableVehicles? avalble,
    List<PageRouteInfo>? children,
  }) : super(
          AvailableVehiclesScreenRoute.name,
          args: AvailableVehiclesScreenRouteArgs(
            key: key,
            avalble: avalble,
          ),
          initialChildren: children,
        );

  static const String name = 'AvailableVehiclesScreenRoute';

  static const PageInfo<AvailableVehiclesScreenRouteArgs> page =
      PageInfo<AvailableVehiclesScreenRouteArgs>(name);
}

class AvailableVehiclesScreenRouteArgs {
  const AvailableVehiclesScreenRouteArgs({
    this.key,
    this.avalble,
  });

  final Key? key;

  final AvailableVehicles? avalble;

  @override
  String toString() {
    return 'AvailableVehiclesScreenRouteArgs{key: $key, avalble: $avalble}';
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
/// [OrderSelectPackageScreen]
class OrderSelectPackageScreenRoute extends PageRouteInfo<void> {
  const OrderSelectPackageScreenRoute({List<PageRouteInfo>? children})
      : super(
          OrderSelectPackageScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderSelectPackageScreenRoute';

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
