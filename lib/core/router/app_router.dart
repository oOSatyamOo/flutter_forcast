import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skycast/presentation/pages/details_page.dart';
import 'package:skycast/presentation/pages/home_page.dart';

import '../../domain/entities/weather_forecast.dart';

/// **AppRouter**
/// Centralizes all route configuration for the SkyCast application.
///
/// Handover Notes:
/// - All routes are defined here following Clean Architecture's separation of concerns.
/// - Deep links are supported via `urlPathStrategy` and the route `path` definitions.
/// - The `/details` route accepts both `extra` (in-app navigation) and query parameters
///   for deep linking scenarios where `extra` is not available.
/// - Deep link examples:
///   - Home:    skycast://open/
///   - Details: skycast://open/details?city=London
class AppRouter {
  AppRouter._(); // Private constructor — this is a utility class.

  /// Route path constants — use these everywhere instead of raw strings.
  static const String home = '/';
  static const String details = '/details';

  /// The single [GoRouter] instance for the whole app.
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,

    // --- Deep Link Configuration ---
    // Ensure `android/app/src/main/AndroidManifest.xml` and
    // `ios/Runner/Info.plist` are configured with the `skycast` URL scheme.
    initialLocation: home,

    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: details,
        name: 'details',
        builder: (context, state) {
          // In-app navigation passes the full DailyForecast object via `extra`.
          // Deep links don't have `extra`, so we show a lightweight detail
          // screen pre-populated with just the city name from query params.
          final city = state.uri.queryParameters['city'] ?? '';

          if (state.extra is DailyForecast) {
            // Standard in-app navigation with full data
            return DetailsPage(
              dailyForecast: state.extra as DailyForecast,
              cityName: city,
            );
          }

          // Deep link fallback — show DetailsPage with only city name.
          // The page itself should handle a null/empty dailyForecast gracefully.
          return DeepLinkDetailsPage(cityName: city);
        },
      ),
    ],

    // Global error page for unresolved routes
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

/// **DeepLinkDetailsPage**
/// A lightweight wrapper shown when the user arrives via a deep link to `/details?city=...`.
/// Since deep links don't carry `DailyForecast` object data, we show a notice
/// directing the user to search for the city from the home screen.
class DeepLinkDetailsPage extends StatelessWidget {
  final String cityName;

  const DeepLinkDetailsPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
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
                    ? 'You were linked to "$cityName".\nSearch for it on the home screen to view the full forecast.'
                    : 'Search for a city on the home screen to view the full forecast.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
                onPressed: () => context.go(AppRouter.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
