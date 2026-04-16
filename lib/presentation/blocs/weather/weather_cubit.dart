import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/usecases/get_forecast_usecase.dart';
import 'weather_state.dart';

/// **WeatherCubit**
/// The View-Model structure powering the Presentation layer.
/// 
/// Handover Notes:
/// - Maps structural interactions originating from the UI into Domain UseCase triggers.
/// - Stores a debouncing `Timer` resolving API over-fetching. A user typing 'London' bounds to 1 Call.
/// - Converts `fpdart`'s `Failure` maps rigidly to `WeatherError(message)` states seamlessly ensuring 
///   the `HomePage` uses simple `if (state is WeatherError)` checking.
class WeatherCubit extends Cubit<WeatherState> {
  final GetForecastUseCase getForecastUseCase;
  final NetworkInfo networkInfo;
  Timer? _debounce;
  
  WeatherCubit({
    required this.getForecastUseCase,
    required this.networkInfo,
  }) : super(WeatherInitial());

  void searchCityChanged(String cityName) {
    if (cityName.isEmpty) {
      emit(WeatherInitial());
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 2), () {
      getForecastForCity(cityName);
    });
  }

  Future<void> getForecastForCity(String cityName) async {
    emit(WeatherLoading());

    final failureOrWeather = await getForecastUseCase(cityName);
    final isConnected = await networkInfo.isConnected;

    failureOrWeather.fold(
      (failure) {
        if (failure is ServerFailure && failure.fallbackData != null) {
          emit(WeatherLoaded(
            forecast: failure.fallbackData!,
            isOffline: !isConnected,
            errorMessage: failure.message,
          ));
        } else {
          emit(WeatherError(message: _mapFailureToMessage(failure)));
        }
      },
      (forecast) => emit(WeatherLoaded(
        forecast: forecast,
        isOffline: !isConnected, 
      )),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server exception or Data limit reached. Please try again.';
      case CacheFailure:
        return failure.message.isNotEmpty 
            ? failure.message 
            : 'No Cache Data Found. Please connect offline.';
      case NetworkFailure:
        return 'No Internet Connection.';
      default:
        return 'Unexpected Error.';
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
