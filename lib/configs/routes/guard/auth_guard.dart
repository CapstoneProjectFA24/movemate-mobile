import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import '../../../utils/providers/common_provider.dart';
import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref _ref;
  AuthGuard({required Ref ref}) : _ref = ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final userData = await SharedPreferencesUtils.getInstance('user_token');
    // final deviceToken = await getDeviceToken();
    if (kDebugMode) {
      // print('device token: $deviceToken');
    }

    if (userData != null) {
      _ref.read(authProvider.notifier).update((state) => userData);
      resolver.next();
    } else {
      router.replaceAll([SignInScreenRoute()]);
    }
  }
}
