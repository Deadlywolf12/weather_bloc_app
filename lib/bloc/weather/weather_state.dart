import 'package:weather_bloc_app/models/forecast_item.dart';
import 'package:weather_bloc_app/models/forecast_response.dart';

abstract class ForecastState {}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastLoaded extends ForecastState {
  final ForecastResponse forecast;

  ForecastLoaded(this.forecast);
}

class ForecastError extends ForecastState {
  final String message;

  ForecastError(this.message);
}
