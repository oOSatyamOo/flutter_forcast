import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/weather_forecast.dart';
import '../repositories/weather_repository.dart';

/// **GetForecastUseCase**
/// Clean Architecture Domain encapsulation bounding the business rules.
/// 
/// Handover Notes:
/// - Following the Single Responsibility Principle, this UseCase ONLY grabs the forecast.
/// - It depends on the `WeatherRepository` Interface (Dependency Inversion), so it literally 
///   does not care if the data comes from Firebase, SQL, Dio, or GraphQL.
/// - It returns an `Either<Failure, WeatherForecast>` leveraging functional programming (`fpdart`)
///   so UI blocks never encounter throw/catch cascades during state emission.
class GetForecastUseCase {
  final WeatherRepository repository;

  GetForecastUseCase(this.repository);

  Future<Either<Failure, WeatherForecast>> call(String cityName) async {
    return await repository.getForecast(cityName);
  }
}
