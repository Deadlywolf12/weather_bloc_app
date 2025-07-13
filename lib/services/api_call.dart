import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/models/forecast_response.dart';

class ApiCall {
  final double longitude;
  final double latitude;

  ApiCall({
    required this.longitude,
    required this.latitude,
  });
  final _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<ForecastResponse> fetchForecast() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> forecastJsonList = json['list'];
      final forecastResponse = ForecastResponse.fromJson(json);
      prefs.setString('forecast_data', jsonEncode(forecastResponse.toJson()));
      prefs.setInt('forecast_expiry', currentTime);
      print("data fetch from api");

      return forecastResponse;
    } else {
      throw Exception(
          'Failed to fetch forecast data. Code: ${response.statusCode}');
    }
  }
}
