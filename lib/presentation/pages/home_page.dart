import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skycast/core/widgets/common_widgets.dart'
    show HeaderWidget, ErrorBanner, DailyCardWidget, OfflineBanner;

import '../../core/router/app_router.dart';
import '../../core/utils/l10n_extension.dart';
import '../../core/utils/lottie_assets.dart';
import '../blocs/weather/weather_cubit.dart';
import '../blocs/weather/weather_state.dart';
import '../../core/widgets/error_retry.dart';

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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  context.read<WeatherCubit>().searchCityChanged(val);
                },
              )
            : Text(l10n.appName),
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
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return Center(
              child: Lottie.asset(LottieAsset.showSearchWaiting, width: 120),
            );
          } else if (state is WeatherError) {
            return ErrorRetry(
              message: state.message,
              onRetry: () {
                // Re-fire the last search query or fall back to the default city.
                final query = _searchController.text.isNotEmpty
                    ? _searchController.text
                    : 'London';
                context.read<WeatherCubit>().getForecastForCity(query);
              },
            );
          } else if (state is WeatherLoaded) {
            final forecast = state.forecast;
            final isOffline = state.isOffline;
            final errorMessage = state.errorMessage;
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
                  if (errorMessage != null) ErrorBanner(message: errorMessage),
                  HeaderWidget(forecast: forecast),
                  const SizedBox(height: 24),
                  Text(
                    l10n.threeDayForecast,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...forecast.dailyForecasts.map(
                    (d) =>
                        DailyCardWidget(cityName: forecast.city.name, day: d),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text(l10n.searchForCity));
        },
      ),
    );
  }
}
