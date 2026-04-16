import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skycast/domain/entities/city.dart';
import 'package:skycast/domain/entities/weather_forecast.dart';
import 'package:skycast/domain/repositories/weather_repository.dart';
import 'package:skycast/domain/usecases/get_forecast_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastUseCase usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetForecastUseCase(mockRepository);
  });

  const tCityName = 'London';
  final tWeatherForecast = WeatherForecast(
    city: const City(name: 'London', country: 'UK'),
    dailyForecasts: const [],
  );

  test('should get forecast for the city from the repository', () async {
    // arrange
    when(() => mockRepository.getForecast(any()))
        .thenAnswer((_) async => Right(tWeatherForecast));
    
    // act
    final result = await usecase(tCityName);
    
    // assert
    expect(result, Right(tWeatherForecast));
    verify(() => mockRepository.getForecast(tCityName));
    verifyNoMoreInteractions(mockRepository);
  });
}
