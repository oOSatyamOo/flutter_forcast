import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/router/app_router.dart';
import '../../core/utils/lottie_assets.dart';
import '../../domain/repositories/app_session_repository.dart';
import '../../domain/usecases/session/session_usecases.dart';

/// **SplashPage**
/// - Saves `open_time` to SQLite via [SaveOpenTimeUseCase] on init.
/// - Displays Lottie animation for 2.5 seconds then navigates to Home.
/// - Implements [WidgetsBindingObserver] so it cleanly tracks lifecycle.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) context.go(AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              LottieAsset.showSearchWaiting,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              'SkyCast',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your personal weather forecast",
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// **SplashRouteWrapper**
/// Wraps [SplashPage] with repository access so open_time is saved.
/// Used in [AppRouter] instead of [SplashPage] directly.
class SplashRouteWrapper extends StatefulWidget {
  final AppSessionRepository repository;
  const SplashRouteWrapper({super.key, required this.repository});

  @override
  State<SplashRouteWrapper> createState() => _SplashRouteWrapperState();
}

class _SplashRouteWrapperState extends State<SplashRouteWrapper> {
  @override
  void initState() {
    super.initState();
    _saveOpenTime();
  }

  Future<void> _saveOpenTime() async {
    final useCase = SaveOpenTimeUseCase(widget.repository);
    await useCase(DateTime.now());
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (mounted) context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              LottieAsset.showSearchWaiting,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              'SkyCast',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personal weather forecast',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
