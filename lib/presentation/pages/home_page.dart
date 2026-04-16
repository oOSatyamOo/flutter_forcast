import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/lottie_assets.dart';
import '../../domain/entities/weather_forecast.dart';
import '../blocs/weather/weather_cubit.dart';
import '../blocs/weather/weather_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Default search to kick things off
    context.read<WeatherCubit>().getForecastForCity('London');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search city...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  context.read<WeatherCubit>().searchCityChanged(val);
                },
              )
            : const Text('SkyCast'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  context.read<WeatherCubit>().getForecastForCity('London');
                } else {
                  _isSearching = true;
                }
              });
            },
          )
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return Center(child: Lottie.asset(LottieAsset.showSearchWaiting, width: 120));
          } else if (state is WeatherError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else if (state is WeatherLoaded) {
            final forecast = state.forecast;
            final isOffline = state.isOffline;
            return RefreshIndicator(
              onRefresh: () async {
                final query = _searchController.text.isNotEmpty
                    ? _searchController.text
                    : forecast.city.name;
                await context.read<WeatherCubit>().getForecastForCity(query);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  if (isOffline) const OfflineBanner(),
                  HeaderWidget(forecast: forecast),
                  const SizedBox(height: 24),
                  const Text('3-Day Forecast',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...forecast.dailyForecasts.map(
                      (d) => DailyCardWidget(cityName: forecast.city.name, day: d)),
                ],
              ),
            );
          }
          return const Center(child: Text("Search for a city"));
        },
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You are offline. Showing cached data.',
              style: TextStyle(color: Colors.deepOrange),
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
            imageUrl: 'https://openweathermap.org/img/wn/${today.iconCode}@4x.png',
            errorWidget: (_, __, ___) => const Icon(Icons.cloud, size: 100),
            width: 120,
            height: 120,
            placeholder: (context, url) => SizedBox(
              width: 120,
              height: 120,
              child: Center(child: Lottie.asset(LottieAsset.showSearchWaiting, width: 60)),
            ),
          ),
          Text(
            '${today.maxTemp.round()}°C',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
          ),
          Text(
            today.condition,
            style: const TextStyle(fontSize: 24),
          ),
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

  const DailyCardWidget({
    super.key,
    required this.cityName,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _dateFormat.format(day.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          context.push(
            Uri(path: '/details', queryParameters: {'city': cityName})
                .toString(),
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
