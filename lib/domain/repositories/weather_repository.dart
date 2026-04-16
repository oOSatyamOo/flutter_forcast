import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/weather_forecast.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherForecast>> getForecast(String cityName);
}
