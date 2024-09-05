import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/commons/functions/shared_preference_utils.dart';
import '../app_router.dart';

// Onboarding Guard
class OnboardingGuard extends AutoRouteGuard {
  final Ref _ref;

  OnboardingGuard({required Ref ref}) : _ref = ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isOnboardingCompleted =
        await SharedPreferencesUtils.isOnboardingCompleted();

    if (isOnboardingCompleted) {
      resolver.next(true);
    } else {
      resolver.redirect(OnboardingScreenRoute());
    }
  }
}
