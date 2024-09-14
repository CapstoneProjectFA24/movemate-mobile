import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/splash_screen.dart';
import 'configs/routes/app_router.dart';
import 'configs/theme/app_theme.dart';
import 'utils/constants/asset_constant.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // widget binding with native platform
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();

  // await Future.delayed(
  //   const Duration(seconds: 1),
  // );

  // FlutterNativeSplash.remove();

  // Khóa thiết bị ở chế độ dọc
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: AssetsConstants.appTitle,
//       theme: AppTheme.theme.copyWith(
//         textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
//       ),
//       routerConfig: ref.watch(appRouterProvider).config(),
//     );
//   }
// }

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _showSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Thời gian hiển thị SplashScreen (3 giây)
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _showSplashScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplashScreen) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    // Nếu không hiển thị SplashScreen, trả về ứng dụng chính
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
