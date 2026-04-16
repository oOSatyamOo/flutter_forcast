import 'package:equatable/equatable.dart';
import 'package:skycast/domain/entities/city.dart' show City;

class HourlyForecast extends Equatable {
  final DateTime time;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String condition;
  final String iconCode;

  const HourlyForecast({
    required this.time,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.condition,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [
    time,
    temp,
    feelsLike,
    humidity,
    windSpeed,
    pressure,
    condition,
    iconCode,
  ];
}

class DailyForecast extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final String iconCode;
  final List<HourlyForecast> hourlyForecasts;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.iconCode,
    required this.hourlyForecasts,
  });

  @override
  List<Object?> get props => [
    date,
    minTemp,
    maxTemp,
    condition,
    iconCode,
    hourlyForecasts,
  ];
}

class WeatherForecast extends Equatable {
  final City city;
  final List<DailyForecast> dailyForecasts;

  const WeatherForecast({required this.city, required this.dailyForecasts});

  @override
  List<Object?> get props => [city, dailyForecasts];
}
