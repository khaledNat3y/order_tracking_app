import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking_app/core/di/dependency_injection.dart';
import 'package:order_tracking_app/core/utils/storage_helper.dart';
import '../../core/routing/app_routes.dart';
import '../../core/styling/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final FirebaseAuth _auth = getIt<FirebaseAuth>();

  @override
  void initState() {
    getIt<StorageHelper>().removeUserId();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    checkAuthStatus();
    super.initState();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      /// User is signed in with Firebase
      await getIt<StorageHelper>().saveUserId(currentUser.uid);
      context.pushReplacementNamed(AppRoutes.homeScreen);
    } else {
      /// Check if we have a stored user ID
      final storedUserId = await getIt<StorageHelper>().getUserId();
      if (storedUserId != null) {
        context.pushReplacementNamed(AppRoutes.homeScreen);
      } else {
        context.pushReplacementNamed(AppRoutes.loginScreen);
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: Image.asset(AppAssets.logo, width: 200.w, height: 200.w),
        ),
      ),
    );
  }
}