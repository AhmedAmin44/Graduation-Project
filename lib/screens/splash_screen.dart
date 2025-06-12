import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graduation_app/cache/cache_helper.dart';
import 'package:graduation_app/core/utils/app_colors.dart';
import 'package:graduation_app/core/utils/app_string.dart';
import 'package:graduation_app/core/utils/app_text_style.dart';
import 'package:graduation_app/screens/on_boarding_screen.dart';
import 'package:graduation_app/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _opacityController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _isMounted = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeIn),
    );

    _runAnimations();

    // التنقل بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () async {
      if (!_isMounted) return;

      bool isOnboardingVisited =
          getIt<CacheHelper>().getData(key: "isOnboardingVisited") ?? false;
      print("🧪 isOnboardingVisited في Splash: $isOnboardingVisited");

      String? token = getIt<CacheHelper>().getData(key: "token");

      if (!isOnboardingVisited) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        );
      } else if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  void _runAnimations() async {
    if (!_isMounted) return;
    await _controller.forward();
    await _opacityController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_isMounted) return;
    await _opacityController.reverse();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_isMounted) return;
    await _opacityController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _isMounted = false;
    _controller.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.prColor,
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 200, width: 200),
                const SizedBox(height: 50),
                Text(
                  AppStrings.appName,
                  style: CustomTextStyles.pacifico400style64.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
