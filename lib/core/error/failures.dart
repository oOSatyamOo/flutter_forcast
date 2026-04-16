import 'package:equatable/equatable.dart';

import '../../domain/entities/weather_forecast.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final WeatherForecast? fallbackData;
  const ServerFailure([super.message = "Server error occurred", this.fallbackData]);

  @override
  List<Object?> get props => [message, fallbackData];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache error occurred"]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}
