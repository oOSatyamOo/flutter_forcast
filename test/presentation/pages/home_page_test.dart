import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skycast/core/widgets/common_widgets.dart' show DailyCardWidget;
import 'package:skycast/domain/entities/city.dart';
import 'package:skycast/domain/entities/weather_forecast.dart';
import 'package:skycast/presentation/blocs/weather/weather_cubit.dart';
import 'package:skycast/presentation/blocs/weather/weather_state.dart';
import 'package:skycast/presentation/pages/home_page.dart';

class MockWeatherCubit extends Mock implements WeatherCubit {}

void main() {
  late MockWeatherCubit mockWeatherCubit;

  setUpAll(() {
    // Required to prevent NetworkImage errors from cached_network_image under test
    HttpOverrides.global = null;
  });

  setUp(() {
    mockWeatherCubit = MockWeatherCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<WeatherCubit>.value(
        value: mockWeatherCubit,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('should display loading indicator when state is WeatherLoading', (
    tester,
  ) async {
    when(() => mockWeatherCubit.state).thenReturn(WeatherLoading());
    // required since we call getForecastForCity('London') in initState
    when(
      () => mockWeatherCubit.getForecastForCity(any()),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    // verify
    expect(find.byType(Lottie), findsOneWidget);
  });

  testWidgets('should display error message when state is WeatherError', (
    tester,
  ) async {
    when(
      () => mockWeatherCubit.state,
    ).thenReturn(const WeatherError(message: 'Test Error'));
    when(
      () => mockWeatherCubit.getForecastForCity(any()),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Error'), findsOneWidget);
  });

  testWidgets(
    'should display forecast and daily cards when state is WeatherLoaded',
    (tester) async {
      final tWeatherForecast = WeatherForecast(
        city: const City(name: 'Paris', country: 'FR'),
        dailyForecasts: [
          DailyForecast(
            date: DateTime(2023, 10, 10),
            minTemp: 10,
            maxTemp: 20,
            condition: 'Clear',
            iconCode: '01d',
            hourlyForecasts: const [],
          ),
        ],
      );

      when(
        () => mockWeatherCubit.state,
      ).thenReturn(WeatherLoaded(forecast: tWeatherForecast, isOffline: true));
      when(
        () => mockWeatherCubit.getForecastForCity(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);

      // Offline Banner Text
      expect(
        find.text('You are offline. Showing cached data.'),
        findsOneWidget,
      );

      // Check if sub widget is rendered
      expect(find.byType(DailyCardWidget), findsWidgets);
    },
  );
}
