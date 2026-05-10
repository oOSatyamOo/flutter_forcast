import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/weather/weather_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before anything else — DioClient and DB need these values.
  await dotenv.load(fileName: ".env");

  // Initialise all get_it service locator bindings.
  di.init();

  runApp(const MyApp());
}

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

        // Router config is now fully managed by AppRouter.
        routerConfig: AppRouter.router,
      ),
    );
  }
}
