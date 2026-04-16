import '../../domain/entities/weather_forecast.dart';
import 'city_model.dart';
import 'package:intl/intl.dart';

class HourlyForecastModel extends HourlyForecast {
  const HourlyForecastModel({
    required super.time,
    required super.temp,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.pressure,
    required super.condition,
    required super.iconCode,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];

    return HourlyForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      pressure: main['pressure'] as int,
      condition: weather['main'] as String,
      iconCode: weather['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': time.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temp,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {'main': condition, 'icon': iconCode}
      ],
      'wind': {'speed': windSpeed},
    };
  }
}

class DailyForecastModel extends DailyForecast {
  const DailyForecastModel({
    required super.date,
    required super.minTemp,
    required super.maxTemp,
    required super.condition,
    required super.iconCode,
    required super.hourlyForecasts,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'condition': condition,
      'iconCode': iconCode,
      'hourlyForecasts':
          (hourlyForecasts as List<HourlyForecastModel>).map((e) => e.toJson()).toList(),
    };
  }

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      iconCode: json['iconCode'] as String,
      hourlyForecasts: (json['hourlyForecasts'] as List)
          .map((e) => HourlyForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({
    required super.city,
    required super.dailyForecasts,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List;
    final cityJson = json['city'] as Map<String, dynamic>;

    final cityModel = CityModel.fromJson(cityJson);
    final List<HourlyForecastModel> hourlyData = 
        list.map((e) => HourlyForecastModel.fromJson(e)).toList();

    // Grouping by Date string (e.g. "2023-10-14")
    final Map<String, List<HourlyForecastModel>> grouped = {};
    for (var hour in hourlyData) {
      final dateKey = DateFormat('yyyy-MM-dd').format(hour.time.toLocal());
      grouped.putIfAbsent(dateKey, () => []).add(hour);
    }

    final List<DailyForecastModel> dailyList = [];
    grouped.forEach((dateStr, hours) {
      // Find min and max
      double min = hours.first.temp;
      double max = hours.first.temp;
      // Get majority condition/icon (or just middle of the day ~12:00 / first)
      String condition = hours.first.condition;
      String iconCode = hours.first.iconCode;
      
      // Let's find index closed to midday locally
      HourlyForecastModel? middayHour;

      for (var h in hours) {
        if (h.temp < min) min = h.temp;
        if (h.temp > max) max = h.temp;
        if (h.time.toLocal().hour >= 11 && h.time.toLocal().hour <= 15) {
          middayHour = h;
        }
      }

      if (middayHour != null) {
        condition = middayHour.condition;
        iconCode = middayHour.iconCode;
      }

      dailyList.add(DailyForecastModel(
        date: DateTime.parse(dateStr),
        minTemp: min,
        maxTemp: max,
        condition: condition,
        iconCode: iconCode,
        hourlyForecasts: hours,
      ));
    });

    // Ensure they are sorted by date
    dailyList.sort((a, b) => a.date.compareTo(b.date));

    // Optional: filter only next 3 days
    final limitList = dailyList.take(4).toList(); // Includes today + 3 days or just 3 days

    return WeatherForecastModel(
      city: cityModel,
      dailyForecasts: limitList,
    );
  }

  // To save/load from sqflite string JSON (simplifying local storage mapping)
  Map<String, dynamic> toJsonWrapper() {
    return {
      'city': (city as CityModel).toJson(),
      'daily': (dailyForecasts as List<DailyForecastModel>)
          .map((e) => e.toJson())
          .toList(),
    };
  }

  factory WeatherForecastModel.fromJsonWrapper(Map<String, dynamic> json) {
    return WeatherForecastModel(
      city: CityModel.fromJson(json['city']),
      dailyForecasts: (json['daily'] as List)
          .map((e) => DailyForecastModel.fromJson(e))
          .toList(),
    );
  }
}
