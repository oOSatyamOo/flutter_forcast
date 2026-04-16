import 'package:equatable/equatable.dart';
import '../../../domain/entities/weather_forecast.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherForecast forecast;
  final bool isOffline;

  const WeatherLoaded({
    required this.forecast,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [forecast, isOffline];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}
