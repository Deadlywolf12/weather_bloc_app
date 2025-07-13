// forecast_response.dart
import 'forecast_item.dart';
import 'city_data.dart';

class ForecastResponse {
  final List<ForecastItem> forecastList;
  final City city;

  ForecastResponse({
    required this.forecastList,
    required this.city,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      forecastList: (json['list'] as List)
          .map((item) => ForecastItem.fromJson(item))
          .toList(),
      city: City.fromJson(json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': forecastList.map((f) => f.toJson()).toList(),
      'city': city.toJson(),
    };
  }
}
