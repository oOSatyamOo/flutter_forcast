import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/lottie_assets.dart';
import '../../domain/entities/weather_forecast.dart';

class DetailsPage extends StatelessWidget {
  final DailyForecast dailyForecast;
  final String cityName;

  // Cached DateFormat for Date Header
  static final _dateFormat = DateFormat('EEEE, MMM d');

  const DetailsPage({
    super.key,
    required this.dailyForecast,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _dateFormat.format(dailyForecast.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            dateStr,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Daily Overview',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DaySummaryWidget(dailyForecast: dailyForecast),
          const SizedBox(height: 32),
          const Text('Hourly Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          HourlyListWidget(forecasts: dailyForecast.hourlyForecasts),
        ],
      ),
    );
  }
}

class DaySummaryWidget extends StatelessWidget {
  final DailyForecast dailyForecast;

  const DaySummaryWidget({super.key, required this.dailyForecast});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _InfoItemWidget(
            icon: Icons.thermostat,
            value: '${dailyForecast.maxTemp.round()}°C',
            label: 'Max Temp'),
        _InfoItemWidget(
            icon: Icons.thermostat_outlined,
            value: '${dailyForecast.minTemp.round()}°C',
            label: 'Min Temp'),
        _InfoItemWidget(
            icon: Icons.cloud,
            value: dailyForecast.condition,
            label: 'Condition'),
      ],
    );
  }
}

class _InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItemWidget({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class HourlyListWidget extends StatelessWidget {
  final List<HourlyForecast> forecasts;

  static final _timeFormat = DateFormat('h a');

  const HourlyListWidget({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemExtent: 92, // Fixed width (80) + padding (12) optimizes calculating render constraints
        itemBuilder: (context, index) {
          final hour = forecasts[index];
          final timeStr = _timeFormat.format(hour.time.toLocal());

          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(timeStr,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                CachedNetworkImage(
                  imageUrl:
                      'https://openweathermap.org/img/wn/${hour.iconCode}.png',
                  width: 50,
                  height: 50,
                  placeholder: (context, url) => SizedBox(
                    width: 40,
                    height: 40,
                    child: Lottie.asset(LottieAsset.showSearchWaiting),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.cloud),
                ),
                Text('${hour.temp.round()}°',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
