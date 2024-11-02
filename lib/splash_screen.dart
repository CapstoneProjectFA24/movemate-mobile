import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'dart:ui';

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    final opacityAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.0).animate(animationController),
    );

    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        animationController.forward().then((_) {
          context.router.replace(OnboardingScreenRoute());
        });
      });
      return animationController.dispose;
    }, []);

    return Scaffold(
      body: Opacity(
        opacity: opacityAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image.asset(
                AssetsConstants.spashImage,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AssetsConstants.primaryMain.withOpacity(0.9),
                      AssetsConstants.primaryMain.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetsConstants.spashLogo,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      AssetsConstants.appTitle,
                      style: AssetsConstants.appFont.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
