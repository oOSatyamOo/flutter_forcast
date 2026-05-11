import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/app_session_repository.dart';
import '../../core/utils/l10n_extension.dart';
import '../di/injection_container.dart';
import 'package:skycast/presentation/pages/details_page.dart';
import 'package:skycast/presentation/pages/home_page.dart';
import 'package:skycast/presentation/pages/settings_page.dart';
import 'package:skycast/presentation/pages/splash_page.dart';

/// **AppRouter** — Single source of truth for all route definitions.
///
/// Routes:
///   /splash    → SplashPage  (initial location — saves open_time)
///   /          → HomePage
///   /details   → DetailsPage (in-app) or DeepLinkDetailsPage (deep link)
///   /settings  → SettingsPage
///
/// Deep links supported via `skycast://` custom URL scheme.
/// Configure AndroidManifest.xml and Info.plist accordingly.
class AppRouter {
  AppRouter._();

  static const String splash   = '/splash';
  static const String home     = '/';
  static const String details  = '/details';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => SplashRouteWrapper(
          repository: sl<AppSessionRepository>(),
        ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: details,
        name: 'details',
        builder: (context, state) {
          final city = state.uri.queryParameters['city'] ?? '';
          if (state.extra is DailyForecast) {
            return DetailsPage(
              dailyForecast: state.extra as DailyForecast,
              cityName: city,
            );
          }
          return DeepLinkDetailsPage(cityName: city);
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}

/// Deep link fallback page shown when app is opened via `skycast:///details?city=X`
/// without in-app DailyForecast object data available.
class DeepLinkDetailsPage extends StatelessWidget {
  final String cityName;
  const DeepLinkDetailsPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(cityName.isNotEmpty ? cityName : 'SkyCast')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link, size: 64, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Text(
                cityName.isNotEmpty
                    ? l10n.deepLinkMessage(cityName)
                    : l10n.deepLinkMessageEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: Text(l10n.goHome),
                onPressed: () => context.go(AppRouter.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
