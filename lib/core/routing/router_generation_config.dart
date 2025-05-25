import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/features/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/features/auth/logic/auth_cubit.dart';
import 'package:order_tracking_app/features/home/ui/home_screen.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';
import 'package:order_tracking_app/features/order_screen/ui/my_orders_screen.dart';
import 'package:order_tracking_app/features/order_screen/ui/order_track_map_screen.dart';
import 'package:order_tracking_app/features/order_screen/ui/search_my_order_screen.dart';
import 'package:order_tracking_app/features/order_screen/ui/user_track_order_map_screen.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/order_screen/data/model/order_model.dart';
import '../../features/order_screen/ui/add_order_screen.dart';
import '../../features/order_screen/ui/place_picker_screen.dart';
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
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => getIt<OrdersCubit>(),
              child: AddOrderScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.ordersScreen,
        path: AppRoutes.ordersScreen,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => getIt<OrdersCubit>(),
              child: MyOrdersScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.orderTrackScreen,
        path: AppRoutes.orderTrackScreen,
        builder: (context, state) {
          final orderModel = state.extra as OrderModel;
          return BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: OrderTrackMapScreen(orderModel: orderModel),
          );
        }
      ),
      GoRoute(
          name: AppRoutes.searchMyOrderScreen,
          path: AppRoutes.searchMyOrderScreen,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => getIt<OrdersCubit>(),
              child: SearchMyOrderScreen(),
            );
          }
      ),
      GoRoute(
          name: AppRoutes.trackMyOrderUserMap,
          path: AppRoutes.trackMyOrderUserMap,
          builder: (context, state) {
            final orderModel = state.extra as OrderModel;
            return BlocProvider(
              create: (context) => getIt<OrdersCubit>(),
              child: UserTrackOrderMapScreen(orderModel: orderModel),
            );
          }
      ),
      GoRoute(
        name: AppRoutes.placePickerScreen,
        path: AppRoutes.placePickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
    ],
  );
}
