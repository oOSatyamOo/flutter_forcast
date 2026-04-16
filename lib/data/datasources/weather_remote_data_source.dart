import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/error/exceptions.dart';
import '../models/weather_forecast_model.dart';
import '../../core/network/dio_client.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherForecastModel> getForecast(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioClient dioClient;

  WeatherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<WeatherForecastModel> getForecast(String city) async {
    final apiKey = dotenv.env['API_KEY'] ?? '';

    try {
      final response = await dioClient.dio.get(
        '/forecast',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherForecastModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout) {
          // You could throw a specific TimeoutException here if desired
          throw ServerException(); 
        }
      }
      throw ServerException();
    }
  }
}
