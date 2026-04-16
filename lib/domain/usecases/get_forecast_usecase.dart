import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/weather_forecast.dart';
import '../repositories/weather_repository.dart';

class GetForecastUseCase {
  final WeatherRepository repository;

  GetForecastUseCase(this.repository);

  Future<Either<Failure, WeatherForecast>> call(String cityName) async {
    return await repository.getForecast(cityName);
  }
}
