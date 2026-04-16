import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:skycast/core/utils/lottie_assets.dart';
import 'package:skycast/domain/entities/weather_forecast.dart';

class ErrorBanner extends StatelessWidget {
  final String message;

  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'API Error: $message. Showing cached data.',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final WeatherForecast forecast;

  const HeaderWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.dailyForecasts.isEmpty) return const SizedBox();
    final today = forecast.dailyForecasts.first;

    return Center(
      child: Column(
        children: [
          Text(
            forecast.city.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            forecast.city.country,
            style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${today.iconCode}@4x.png',
            errorWidget: (_, __, ___) => const Icon(Icons.cloud, size: 100),
            width: 120,
            height: 120,
            placeholder: (context, url) => SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: Lottie.asset(LottieAsset.showSearchWaiting, width: 60),
              ),
            ),
          ),
          Text(
            '${today.maxTemp.round()}°C',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
          ),
          Text(today.condition, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

class DailyCardWidget extends StatelessWidget {
  final String cityName;
  final DailyForecast day;

  // Cache DateFormat instance
  static final _dateFormat = DateFormat('EEEE, MMM d');

  const DailyCardWidget({super.key, required this.cityName, required this.day});

  @override
  Widget build(BuildContext context) {
    final dateStr = _dateFormat.format(day.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          context.push(
            Uri(
              path: '/details',
              queryParameters: {'city': cityName},
            ).toString(),
            extra: day,
          );
        },
        leading: CachedNetworkImage(
          imageUrl: 'https://openweathermap.org/img/wn/${day.iconCode}.png',
          errorWidget: (_, __, ___) => const Icon(Icons.cloud),
          placeholder: (context, url) => SizedBox(
            width: 40,
            height: 40,
            child: Lottie.asset(LottieAsset.showSearchWaiting),
          ),
        ),
        title: Text(dateStr),
        subtitle: Text(day.condition),
        trailing: Text(
          '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
