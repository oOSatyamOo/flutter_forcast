import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skycast/core/error/failures.dart';
import 'package:skycast/core/network/network_info.dart';
import 'package:skycast/domain/entities/city.dart';
import 'package:skycast/domain/entities/weather_forecast.dart';
import 'package:skycast/domain/usecases/get_forecast_usecase.dart';
import 'package:skycast/presentation/blocs/weather/weather_cubit.dart';
import 'package:skycast/presentation/blocs/weather/weather_state.dart';

class MockGetForecastUseCase extends Mock implements GetForecastUseCase {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WeatherCubit cubit;
  late MockGetForecastUseCase mockGetForecastUseCase;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockGetForecastUseCase = MockGetForecastUseCase();
    mockNetworkInfo = MockNetworkInfo();
    cubit = WeatherCubit(
      getForecastUseCase: mockGetForecastUseCase,
      networkInfo: mockNetworkInfo,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tWeatherForecast = WeatherForecast(
    city: const City(name: 'London', country: 'UK'),
    dailyForecasts: const [],
  );

  test('initial state should be WeatherInitial', () {
    expect(cubit.state, equals(WeatherInitial()));
  });

  blocTest<WeatherCubit, WeatherState>(
    'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully (online)',
    build: () {
      when(() => mockGetForecastUseCase(any()))
          .thenAnswer((_) async => Right(tWeatherForecast));
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.getForecastForCity('London'),
    expect: () => [
      WeatherLoading(),
      WeatherLoaded(forecast: tWeatherForecast, isOffline: false),
    ],
  );

  blocTest<WeatherCubit, WeatherState>(
    'should emit [WeatherLoading, WeatherError] when data fails',
    build: () {
      when(() => mockGetForecastUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.getForecastForCity('London'),
    expect: () => [
      WeatherLoading(),
      const WeatherError(message: 'Server exception or Data limit reached. Please try again.'),
    ],
  );
}
