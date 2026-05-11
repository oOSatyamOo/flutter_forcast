import 'package:skycast/domain/entities/app_session.dart';
import 'package:skycast/domain/repositories/app_session_repository.dart';

/// Records session open time — called by SplashPage on startup.
class SaveOpenTimeUseCase {
  final AppSessionRepository repository;
  SaveOpenTimeUseCase(this.repository);

  Future<AppSession> call(DateTime time) => repository.saveOpenTime(time);
}

/// Records session exit time — called by WidgetsBindingObserver on pause/detach.
class SaveExitTimeUseCase {
  final AppSessionRepository repository;
  SaveExitTimeUseCase(this.repository);

  Future<void> call(DateTime time) => repository.saveExitTime(time);
}
