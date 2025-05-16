import 'package:get_it/get_it.dart';
import 'package:order_tracking_app/core/utils/storage_helper.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //Storage Helper

  getIt.registerLazySingleton(() => StorageHelper());

  // Repos
  // sl.registerLazySingleton(() => AuthRepo(sl<DioHelper>()));
  // sl.registerLazySingleton(() => HomeRepo(sl<DioHelper>()));
  // sl.registerLazySingleton(() => CartRepo(sl<DioHelper>()));

  // Cubit
  // sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
  // sl.registerFactory(() => ProductCubit(sl<HomeRepo>()));
  // sl.registerFactory(() => CategoriesCubit(sl<HomeRepo>()));
  // sl.registerFactory(() => CartCubit(sl<CartRepo>()));
}
