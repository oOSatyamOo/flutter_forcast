import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

/// **WeatherRepositoryImpl** 
/// This class acts as the single source of truth for the Domain Layer. 
/// It implements the `WeatherRepository` contract from the Domain Layer natively.
/// 
/// Handover Notes:
/// - Notice how we inject Remote / Local data sources here. This allows the repository
///   to coordinate *where* the data comes from without the upper layers knowing.
/// - We use `NetworkInfo` to gate logic (Online vs Offline routing).
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherForecast>> getForecast(String cityName) async {
    return await _getWeather(() => remoteDataSource.getForecast(cityName));
  }

  /// Centralized logic to fetch weather from Remote, cast as Domain Entities, 
  /// and automatically cache to Local `sqflite`. If it fails, falls back gracefully.
  Future<Either<Failure, WeatherForecast>> _getWeather(
    Future<WeatherForecast> Function() getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      // 1. ONLINE LAYER TRIGGER
      try {
        final remoteForecast = await getConcreteOrRandom();
        
        // We cast remote data into the exact `WeatherForecastModel` explicitly 
        // to pass it strictly down to SQL schemas.
        await localDataSource.cacheForecast(remoteForecast as dynamic);
        
        return Right(remoteForecast);
      } on ServerException {
        // If the API throws 500s or 404s, failover seamlessly gracefully to cached db.
        try {
          final localData = await localDataSource.getLastSavedForecast();
          return Right(localData);
        } on CacheException {
           return const Left(ServerFailure());
        }
      } catch (e) {
         return const Left(ServerFailure());
      }
    } else {
      // 2. OFFLINE LAYER TRIGGER
      try {
        // Look up sqlite fallback records natively
        final localForecast = await localDataSource.getLastSavedForecast();
        // If offline and cache retrieves, return Right data, 
        // Presentation handles offline "banner" by checking network status or state differentiation.
        return Right(localForecast); 
      } on CacheException {
        return const Left(CacheFailure("No cache found. Please connect to internet."));
      }
    }
  }
}

