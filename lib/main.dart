import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'configs/routes/app_router.dart';
import 'configs/theme/app_theme.dart';
import 'utils/constants/asset_constant.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // widget binding with native platform
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.delayed(
    const Duration(seconds: 1),
  );

  FlutterNativeSplash.remove();

  // Khóa thiết bị ở chế độ dọc
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AssetsConstants.appTitle,
      theme: AppTheme.theme.copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
      ),
      routerConfig: ref.watch(appRouterProvider).config(),
    );
  }
}
