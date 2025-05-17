import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/features/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/features/auth/logic/auth_cubit.dart';
import 'package:order_tracking_app/features/home/ui/home_screen.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/splash_screen/splash_screen.dart';
import '../di/dependency_injection.dart';
import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => getIt<AuthCubit>(),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => getIt<AuthCubit>(),
              child: RegisterScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
