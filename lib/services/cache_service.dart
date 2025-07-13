import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/models/forecast_response.dart';
import 'package:weather_bloc_app/services/api_call.dart';

class CacheService {
  final double longitude;
  final double latitude;
  CacheService(this.longitude, this.latitude) {}

  Future<ForecastResponse> GetForecastData() async {
    final prefs = await SharedPreferences.getInstance();
    final ApiCall apiCall = ApiCall(
      longitude: longitude,
      latitude: latitude,
    );
    final cachedData = prefs.getString('forecast_data');
    final cacheExpiry = prefs.getInt('forecast_expiry');

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (cachedData != null &&
        cacheExpiry != null &&
        currentTime - cacheExpiry < 30 * 60 * 1000) {
      final decoded = jsonDecode(cachedData);
      final forecastList = ForecastResponse.fromJson(decoded);

      print("data fetched from cache");

      return forecastList;
    } else {
      return await apiCall.fetchForecast();
    }
  }
}
