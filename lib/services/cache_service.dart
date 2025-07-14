import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/models/city_data.dart';
import 'package:weather_bloc_app/models/forecast_response.dart';
import 'package:weather_bloc_app/services/api_call.dart';

class CacheService {
  final double longitude;
  final double latitude;
  CacheService(this.longitude, this.latitude) {}

  Future<ForecastResponse> GetForecastData(bool useCache, bool isRe) async {
    final prefs = await SharedPreferences.getInstance();
    final ApiCall apiCall = ApiCall(
      longitude: longitude,
      latitude: latitude,
    );
    final cachedData = prefs.getString('forecast_data');
    final cacheExpiry = prefs.getInt('forecast_expiry');

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (useCache && cachedData != null && cacheExpiry != null) {
      return ForecastResponse.fromJson(jsonDecode(cachedData));
    } else if (!useCache &&
        cachedData != null &&
        cacheExpiry != null &&
        !isRe) {
      final isValid = currentTime - cacheExpiry < 10 * 60 * 1000;
      if (isValid) {
        print("⏱ Using cached data from cache service");
        return ForecastResponse.fromJson(jsonDecode(cachedData));
      }
    } else if (!useCache && cachedData != null && cacheExpiry != null && isRe) {
      print("⏱ Using api data from cache service because refresh");
      return await apiCall.fetchForecast();
    }
    print("⏱ Using api data from cache service");
    return await apiCall.fetchForecast();
  }
}
