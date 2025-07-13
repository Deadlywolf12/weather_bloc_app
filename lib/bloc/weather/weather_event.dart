abstract class ForecastEvent {}

class FetchForecast extends ForecastEvent {
  final double latitude;
  final double longitude;

  FetchForecast({required this.latitude, required this.longitude});
}
