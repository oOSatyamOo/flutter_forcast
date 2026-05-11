import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skycast/core/l10n/app_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/app_session_repository.dart';
import 'domain/usecases/session/session_usecases.dart';
import 'presentation/blocs/settings/settings_cubit.dart';
import 'presentation/blocs/settings/settings_state.dart';
import 'presentation/blocs/weather/weather_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before any service reads configuration
  await dotenv.load(fileName: '.env');

  // Initialize all DI bindings
  di.init();

  // Pre-load persisted settings so first frame renders with correct theme/locale
  await di.sl<SettingsCubit>().loadSettings();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Implements [WidgetsBindingObserver] to track app lifecycle.
/// When the app is paused or detached, [SaveExitTimeUseCase] writes
/// the current timestamp to the SQLite session table.
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final SaveExitTimeUseCase _saveExitTimeUseCase;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _saveExitTimeUseCase = SaveExitTimeUseCase(di.sl<AppSessionRepository>());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called by the framework when app lifecycle state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Save exit_time to the most recent session row in SQLite.
      _saveExitTimeUseCase(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SettingsCubit is a LazySingleton — reuse the pre-loaded instance
        BlocProvider<SettingsCubit>.value(value: di.sl<SettingsCubit>()),
        BlocProvider<WeatherCubit>(create: (_) => di.sl<WeatherCubit>()),
      ],
      // BlocBuilder reactively switches theme and locale when SettingsCubit emits
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'SkyCast',
            debugShowCheckedModeBanner: false,

            // ─── Theme ─────────────────────────────────────────────────────
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,

            // ─── Localization ───────────────────────────────────────────────
            locale: settings.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

            // ─── Routing ───────────────────────────────────────────────────
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
