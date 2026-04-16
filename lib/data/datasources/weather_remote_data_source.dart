import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/error/exceptions.dart';
import '../models/weather_forecast_model.dart';
import '../../core/network/dio_client.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherForecastModel> getForecast(String city);
}

/// **WeatherRemoteDataSourceImpl**
/// Manages the network requests out to OpenWeatherMap.
///
/// Handover Notes:
/// - `DioClient` provides an intercepted instance of `Dio` guaranteeing our 10-second timeout constraints natively.
/// - We pull the `API_KEY` dynamically out of the `.env` here to ensure github safety.
/// - The `metric` unit is hardcoded to enforce Celsius measurements. 
/// - `DioException` timeouts route cleanly back out as `ServerException` to allow fallback triggers in the Repository layer.
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
          throw ServerException('Connection timeout'); 
        }
        
        // Extract exact dynamic error message from API (e.g. {"cod":"404","message":"city not found"})
        if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
          final message = e.response?.data['message'] as String?;
          if (message != null) {
            throw ServerException(message);
          }
        }
      }
      throw ServerException();
    }
  }
}
