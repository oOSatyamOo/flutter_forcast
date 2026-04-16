import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'domain/entities/weather_forecast.dart';
import 'presentation/blocs/weather/weather_cubit.dart';
import 'presentation/pages/details_page.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env
  await dotenv.load(fileName: ".env");

  // Init DI
  di.init();

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final dailyForecast = state.extra as DailyForecast;
        final city = state.uri.queryParameters['city'] ?? '';
        return DetailsPage(
          dailyForecast: dailyForecast,
          cityName: city,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(create: (_) => di.sl<WeatherCubit>()),
      ],
      child: MaterialApp.router(
        title: 'SkyCast',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
