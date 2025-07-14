abstract class ForecastEvent {}

class FetchForecast extends ForecastEvent {
  final double? latitude;
  final double? longitude;

  final bool UseCacheOnly;
  final bool isRefresh;

  FetchForecast(
      {this.latitude,
      this.longitude,
      this.UseCacheOnly = false,
      this.isRefresh = false});
}
