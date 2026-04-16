import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/datasources/weather_local_data_source.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../presentation/blocs/weather/weather_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance; // service locator

void init() {
  // Features - Weather
  // Bloc
  sl.registerFactory(
    () => WeatherCubit(getForecastUseCase: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetForecastUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  sl.registerLazySingleton(() => DioClient());

  // External
  sl.registerLazySingleton(() => InternetConnection());
}
