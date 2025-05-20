import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:order_tracking_app/core/utils/storage_helper.dart';
import 'package:order_tracking_app/features/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/features/auth/logic/auth_cubit.dart';
import 'package:order_tracking_app/features/order_screen/data/repo/orders_repo.dart';
import 'package:order_tracking_app/features/order_screen/logic/orders_cubit.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  //Storage Helper
  getIt.registerLazySingleton(() => StorageHelper());

  // Firebase
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  /// Repos
  getIt.registerLazySingleton(
    () => AuthRepo(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton(()=> OrdersRepo(getIt<FirebaseFirestore>()));


  // Cubits
  getIt.registerFactory(() => AuthCubit(getIt<AuthRepo>()));
  getIt.registerFactory(() => OrdersCubit(getIt<OrdersRepo>()));
}
