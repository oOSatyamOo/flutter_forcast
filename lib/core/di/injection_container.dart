import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/datasources/app_local_data_source.dart';
import '../../data/datasources/app_sqlite_local_data_source.dart';
import '../../data/datasources/weather_local_data_source.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/app_session_repository_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/app_session_repository.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../domain/usecases/session/session_usecases.dart';
import '../../domain/usecases/settings/settings_usecases.dart';
import '../../presentation/blocs/settings/settings_cubit.dart';
import '../../presentation/blocs/weather/weather_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

void init() {
  // ─── Presentation ────────────────────────────────────────────────────────
  //////////////////////////////////
  ///
  // SettingsCubit is a LazySingleton — app-wide singleton for reactive theme/locale
  sl.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(
      loadSettingsUseCase: sl(),
      saveThemeUseCase: sl(),
      saveLocaleUseCase: sl(),
      repository: sl(),
    ),
  );
  // Settings use cases
  sl.registerLazySingleton(() => LoadSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveLocaleUseCase(sl()));
  // AppSessionRepository — LazySingleton so the broadcast stream persists
  sl.registerLazySingleton<AppSessionRepository>(
    () => AppSessionRepositoryImpl(localDataSource: sl()),
  );
  ///////////////////////////

  // WeatherCubit is a Factory — new instance per BlocProvider
  sl.registerFactory(
    () => WeatherCubit(getForecastUseCase: sl(), networkInfo: sl()),
  );

  // ─── Use Cases ───────────────────────────────────────────────────────────

  // Session lifecycle use cases
  sl.registerLazySingleton(() => SaveOpenTimeUseCase(sl()));
  sl.registerLazySingleton(() => SaveExitTimeUseCase(sl()));

  // Weather use case
  sl.registerLazySingleton(() => GetForecastUseCase(sl()));

  // ─── Repositories ────────────────────────────────────────────────────────

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ─── Data Sources ────────────────────────────────────────────────────────

  // App settings/session — abstraction bound to sqflite impl
  sl.registerLazySingleton<AppLocalDataSource>(
    () => AppSqliteLocalDataSource(),
  );

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(),
  );

  // ─── Core ────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioClient());

  // ─── External ────────────────────────────────────────────────────────────

  sl.registerLazySingleton(() => InternetConnection());
}
